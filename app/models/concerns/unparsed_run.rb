require 'active_support/concern'

module UnparsedRun
  extend ActiveSupport::Concern

  included do
    class UnparsableRun < StandardError; end
    class RunFileMissing < StandardError; end

    MAX_CONTAINER_SIZE = 1000

    def parsed?
      parsed_at.present?
    end

    def parse_into_db
      with_lock do
        # Use destroy all for segments to make sure active storage images are cleaned up
        segments.destroy_all
        histories.delete_all

        run = nil
        run_data = {}
        file do |f|
          raise RunFileMissing if f.nil?

          Parser::LiveSplitCore::Run.parse_file_handle(f.fileno, '', false).with do |parse_result|
            raise UnparsableRun, 'Run failed to parse in LSC' unless parse_result.parsed_successfully

            run_data = process_run_wrapper(parse_result, run_data)
            run = parse_result.unwrap
          end

          run_data[:size] = File.size(f)
        end

        # Process and write run parts individually, and in batches to prevent loading N objects in memory at once
        run_data = process_run_metadata(run, run_data)
        process_run_history(run)
        process_segments(run)
        # Processing of segment histories is called from process_segments

        add_default_proc!(run_data)

        populate_category(run_data[:game], run_data[:category]) if game.nil? || category.nil?

        update(
          parsed_at:               Time.now.utc,
          program:                 run_data[:program].to_s,
          attempts:                run_data[:attempts],
          srdc_id:                 srdc_id || run_data[:metadata][:srdc_id],
          uses_emulator:           run_data[:metadata][:uses_emulator],
          uses_autosplitter:       run_data[:autosplitter_settings].present?,

          realtime_duration_ms:    zero_to_nil(run_data[:realtime_duration_ms]),
          realtime_sum_of_best_ms: zero_to_nil(run_data[:realtime_sum_of_best_ms]),

          gametime_duration_ms:    zero_to_nil(run_data[:gametime_duration_ms]),
          gametime_sum_of_best_ms: zero_to_nil(run_data[:gametime_sum_of_best_ms]),

          total_playtime_ms:       run_data[:total_playtime_ms],
          default_timing:          run_data[:default_timing],
          filesize_bytes:          run_data[:size],

          platform:                SpeedrunDotComPlatform.find_by(name: run_data[:metadata][:platform_name]),
          region:                  SpeedrunDotComRegion.find_by(name: run_data[:metadata][:region_name])
        )

        HighlightSuggestion.from_run(self)
      end
    rescue UnparsableRun
      destroy
      false
    ensure
      run.dispose if defined?(run)
    end

    def process_run_wrapper(wrapper, run_data)
      run_data[:program] = wrapper.timer_kind
      run_data[:program] = Programs::ExchangeFormat.to_s if Run.program_from_attribute(:to_s, run_data[:program]).nil?

      if wrapper.is_generic_timer && !Run.program_from_attribute(:to_s, run_data[:program]).exchangeable?
        # We got a file in the exchange format, but the reported timer doesn't support the exchange format.
        # Wipe the timer to stop from serving the exchange format when a user asks to download the file in the
        # source timer's format.
        run_data[:program] = Programs::ExchangeFormat.to_s
      end

      run_data[:program] = Run.program_from_attribute(:to_s, run_data[:program]).to_sym

      run_data
    end

    def process_run_metadata(run, run_data)
      run_data[:game]      = run.game_name
      run_data[:game_icon] = run.game_icon.presence
      run_data[:category]  = run.category_name
      run_data[:name]      = run.extended_name(false)

      run_data[:autosplitter_settings] = run.auto_splitter_settings

      run_data[:metadata]                 = {}
      run_data[:metadata][:srdc_id]       = run.metadata.run_id.presence
      run_data[:metadata][:platform_name] = run.metadata.platform_name.presence
      run_data[:metadata][:region_name]   = run.metadata.region_name.presence
      run_data[:metadata][:uses_emulator] = run.metadata.uses_emulator
      run_data[:metadata][:variables]     = {}

      run_data[:attempts]  = run.attempt_count
      run_data[:offset_ms] = run.offset.total_seconds * 1000

      # Grab all run metadata
      # .with will clean up the iterator when we are done
      run.metadata.variables.with do |iter|
        until (variable = iter.next).nil?
          run_data[:metadata][:variables][variable.name] = variable.value
        end
      end

      # Retrieve total playtime, and both sum of bests
      # .with will clean up any objects that will not be GC'd
      Parser::LiveSplitCore::Analysis.calculate_total_playtime_for_run(run)
                                     .with { |analysis| run_data[:total_playtime_ms] = analysis.total_seconds * 1000 }
      analysis = [
        Parser::LiveSplitCore::Analysis.calculate_sum_of_best(run, false, false, 0),
        Parser::LiveSplitCore::Analysis.calculate_sum_of_best(run, false, false, 1)
      ]
      run_data[:realtime_sum_of_best_ms] = analysis[0].present? ? analysis[0].total_seconds * 1000 : 0
      run_data[:gametime_sum_of_best_ms] = analysis[1].present? ? analysis[1].total_seconds * 1000 : 0
      # See https://github.com/glacials/splits-io/pull/474/files#r241242051
      analysis.compact.each(&:dispose)

      # Set run duration
      last_seg = run.segment(run.len - 1) if run.len != 0
      run_data[:realtime_duration_ms] = last_seg&.personal_best_split_time&.real_time&.total_seconds&.*(1000) || 0
      run_data[:gametime_duration_ms] = last_seg&.personal_best_split_time&.game_time&.total_seconds&.*(1000) || 0

      run_data[:default_timing] = Run::REAL
      if run_data[:realtime_duration_ms].zero? && run_data[:gametime_duration_ms].positive?
        run_data[:default_timing] = Run::GAME
      end

      write_run_variables(run_data)
      run_data
    end

    def write_run_variables(run_data)
      srdc_game = SpeedrunDotComGame.find_by(name: run_data[:game])

      run_data[:metadata][:variables].each do |key, value|
        srdc_variable = SpeedrunDotComGameVariable.find_by!(
          speedrun_dot_com_game: srdc_game,
          name:                  key
        )
        srdc_variable_value = srdc_variable.variable_values.find_by!(
          speedrun_dot_com_game_variable: srdc_variable,
          label:                          value
        )
        SpeedrunDotComRunVariable.find_or_create_by!(
          run:                                  self,
          speedrun_dot_com_game_variable_value: srdc_variable_value
        )
      rescue ActiveRecord::RecordNotFound
        next
      end
    end

    def process_run_history(run)
      container = []

      (0...run.attempt_history_len).each_slice(MAX_CONTAINER_SIZE) do |slice|
        slice.each do |i|
          attempt = run.attempt_history_index(i)
          dates = [attempt.started, attempt.ended]

          history = RunHistory.new(
            run_id:               id,
            attempt_number:       attempt.index.to_i,
            realtime_duration_ms: attempt.time.real_time&.total_seconds&.*(1000),
            gametime_duration_ms: attempt.time.game_time&.total_seconds&.*(1000),
            pause_duration_ms:    attempt.pause_time&.total_seconds&.*(1000),
            started_at:           dates[0] && DateTime.parse(dates[0].to_rfc3339),
            ended_at:             dates[1] && DateTime.parse(dates[1].to_rfc3339)
          )

          # See https://github.com/glacials/splits-io/pull/474/files#r241242051
          dates.compact.each(&:dispose)

          container << history
        end

        write_run_histories(container)
        container = []
      end
    end

    def write_run_histories(histories)
      result = RunHistory.import(histories)
      return result unless result.failed_instances.any?

      raise UnparsableRun, 'Failed to write run histories to db'
    end

    def process_segments(run)
      container = {}
      # Use an open struct to track last known end times
      previous_segment = OpenStruct.new(realtime_end_ms: 0, gametime_end_ms: 0)

      (0...run.len).each_slice(MAX_CONTAINER_SIZE) do |slice|
        slice.each do |i|
          lsc_segment = run.segment(i)
          segment = Segment.new(
            run_id:         id,
            segment_number: i,
            name:           lsc_segment.name.presence
          )
          icon = lsc_segment.icon
          if icon.present?
            segment.icon.attach(
              # TODO: in the next LSC release, this will no longer by Data URL
              io:       StringIO.new(Base64.decode64(icon.split('base64,')[1])),
              filename: "#{id}_#{i}"
            )
          end

          segment.realtime_end_ms = lsc_segment.personal_best_split_time.real_time&.total_seconds&.*(1000) || 0
          segment.realtime_duration_ms = [0, segment.realtime_end_ms - previous_segment.realtime_end_ms].max
          segment.realtime_start_ms = segment.realtime_end_ms - segment.realtime_duration_ms
          segment.realtime_shortest_duration_ms = lsc_segment.best_segment_time.real_time&.total_seconds&.*(1000) || 0
          segment.realtime_skipped = segment.realtime_duration_ms.zero?
          if segment.realtime_duration_ms.positive?
            segment.realtime_gold = segment.realtime_duration_ms <= segment.realtime_shortest_duration_ms
          end
          segment.realtime_reduced = false

          segment.gametime_end_ms = lsc_segment.personal_best_split_time.game_time&.total_seconds&.*(1000) || 0
          segment.gametime_duration_ms = [0, segment.gametime_end_ms - previous_segment.gametime_end_ms].max
          segment.gametime_start_ms = segment.gametime_end_ms - segment.gametime_duration_ms
          segment.gametime_shortest_duration_ms = lsc_segment.best_segment_time.game_time&.total_seconds&.*(1000) || 0
          segment.gametime_skipped = segment.gametime_duration_ms.zero?
          if segment.gametime_duration_ms.positive?
            segment.gametime_gold = segment.gametime_duration_ms <= segment.gametime_shortest_duration_ms
          end
          segment.gametime_reduced = false

          container[lsc_segment] = segment
          previous_segment.realtime_end_ms = segment.realtime_end_ms if segment.realtime_end_ms.positive?
          previous_segment.gametime_end_ms = segment.gametime_end_ms if segment.gametime_end_ms.positive?
        end

        result = write_segments(container.values)
        process_segment_histories(container.keys, result.ids)
        container = {}
      end
    end

    def write_segments(segments)
      # nil out all blank times here since we needed them before to be 0's for finding times
      segments.each do |seg|
        %w[real game].each do |timing|
          %w[time_end_ms time_duration_ms time_shortest_duration_ms].each do |field|
            value = seg.send("#{timing}#{field}")
            seg.send("#{timing}#{field}=", zero_to_nil(value))
          end
        end
      end
      result = Segment.import(segments)
      raise UnparsableRun, 'Failed to write segments to db' if result.failed_instances.any?

      # active storage attachments are saved when the record is next saved, not sure if import skips this
      segments.each do |segment|
        segment.save
      end
      result
    end

    def process_segment_histories(lsc_segments, segment_ids)
      container = []

      lsc_segments.each_with_index do |seg, i|
        seg.segment_history.iter.with do |iter|
          until (history_element = iter.next).nil?
            next unless history_element.index.positive?

            container << SegmentHistory.new(
              segment_id:           segment_ids[i],
              attempt_number:       history_element.index,
              realtime_duration_ms: history_element.time.real_time&.total_seconds&.*(1000),
              gametime_duration_ms: history_element.time.game_time&.total_seconds&.*(1000)
            )

            next if container.size < MAX_CONTAINER_SIZE

            write_segment_histories(container)
            container = []
          end
        end
      end

      return if container.blank?

      write_segment_histories(container)
    end

    def write_segment_histories(histories)
      result = SegmentHistory.import(histories)
      return unless result.failed_instances.any?

      raise UnparsableRun, 'Failed to write segment histories to db'
    end

    def zero_to_nil(parsed_number)
      parsed_number = parsed_number.presence
      parsed_number.zero? ? nil : parsed_number
    end
  end

  private

  def add_default_proc!(obj)
    obj.default_proc = ->(_hash, key) { raise KeyError, "#{key} not found" } if obj.respond_to?(:default_proc=)
    return unless obj.respond_to?(:each)

    obj.each do |value|
      add_default_proc!(value)
    end
  end
end
