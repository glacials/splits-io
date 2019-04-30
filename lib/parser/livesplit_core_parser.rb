begin
  require File.expand_path('LiveSplitCore', __dir__)
rescue LoadError
  raise 'Please follow the steps to install livesplit-core in the readme'
end

class Parser
  def self.parse(run)
    parse_result = if run.is_a?(Integer)
                     # If integer, attempt to parse the file descriptor attached to the number
                     LiveSplitCore::Run.parse_file_handle(run, '', false)
                   else
                     # Assume run is already read into a string and parse from memory
                     LiveSplitCore::Run.parse(run, run.length, '', false)
                   end
    return nil unless parse_result.parsed_successfully

    program = parse_result.timer_kind

    program = ExchangeFormat.to_s if Run.program_from_attribute(:to_s, program).nil?

    if parse_result.is_generic_timer && !Run.program_from_attribute(:to_s, program).exchangeable?
      # We got a file in the exchange format, but the reported timer doesn't support the exchange format. Wipe the timer
      # to stop from serving the exchange format when a user asks to download the file in the source timer's format.
      program = ExchangeFormat.to_s
    end

    run = parse_result.unwrap
    run_metadata = run.metadata

    run_object = {
      program: program,
      game: run.game_name,
      game_icon: run.game_icon.presence,
      category: run.category_name,
      name: run.extended_name(false),
      metadata: {
        srdc_id: run_metadata.run_id.presence,
        platform_name: run_metadata.platform_name.presence,
        region_name: run_metadata.region_name.presence,
        uses_emulator: run_metadata.uses_emulator,
        variables: {}
      },
      attempts: run.attempt_count,
      offset_ms: run.offset.total_seconds * 1000,
      history: [],
      splits: [],
      realtime_duration_ms: 0,
      gametime_duration_ms: 0,
      realtime_sum_of_best_ms: 0,
      gametime_sum_of_best_ms: 0,
      total_playtime_ms: 0
    }

    variables_iterator = run_metadata.variables
    until (variable = variables_iterator.next).nil?
      run_object[:metadata][:variables][variable.name] = variable.value
    end
    variables_iterator.dispose

    realtime_sum_of_best = LiveSplitCore::Analysis.calculate_sum_of_best(run, false, false, 0)
    gametime_sum_of_best = LiveSplitCore::Analysis.calculate_sum_of_best(run, false, false, 1)

    unless realtime_sum_of_best.nil?
      run_object[:realtime_sum_of_best_ms] = realtime_sum_of_best.total_seconds * 1000
      realtime_sum_of_best.dispose
    end

    unless gametime_sum_of_best.nil?
      run_object[:gametime_sum_of_best_ms] = gametime_sum_of_best.total_seconds * 1000
      gametime_sum_of_best.dispose
    end

    total_playtime = LiveSplitCore::Analysis.calculate_total_playtime_for_run(run)
    run_object[:total_playtime_ms] = total_playtime.total_seconds * 1000
    total_playtime.dispose

    run_object[:history] = []
    (0...run.attempt_history_len).each do |i|
      attempt = run.attempt_history_index(i)
      attempt_id = attempt.index.to_i
      time = attempt.time

      # See https://github.com/glacials/splits-io/pull/474/files#r241242051
      attempt_started = attempt.started
      attempt_ended = attempt.ended

      run_object[:history] << {
        attempt_number:       attempt_id,
        realtime_duration_ms: time.real_time.try(:total_seconds).try(:*, 1000) || 0,
        gametime_duration_ms: time.game_time.try(:total_seconds).try(:*, 1000) || 0,

        started_at: attempt_started && DateTime.parse(attempt_started.to_rfc3339),
        ended_at:   attempt_ended   && DateTime.parse(attempt_ended.to_rfc3339),

        pause_duration_ms: attempt.pause_time.try(:total_seconds).try(:*, 1000)
      }

      # See https://github.com/glacials/splits-io/pull/474/files#r241242051
      [attempt_started, attempt_ended].compact.each(&:dispose)
    end

    (0...run.len).each do |i|
      segment = run.segment(i)
      split = {
        segment_number: i,
        name: segment.name,
        icon: segment.icon.presence,
        realtime_gold: false,
        realtime_skipped: false,
        gametime_gold: false,
        gametime_skipped: false,
        history: []
      }

      split[:realtime_end_ms] = (segment.personal_best_split_time.real_time.try(:total_seconds) || 0) * 1000
      split[:realtime_duration_ms] = [0, split[:realtime_end_ms] - run_object[:realtime_duration_ms]].max
      split[:realtime_start_ms] = split[:realtime_end_ms] - split[:realtime_duration_ms]

      split[:realtime_best_ms] = (segment.best_segment_time.real_time.try(:total_seconds) || 0) * 1000
      split[:realtime_skipped] = split[:realtime_duration_ms].zero?

      if split[:realtime_duration_ms].positive?
        split[:realtime_gold] = true if split[:realtime_duration_ms] <= split[:realtime_best_ms]
      end

      split[:gametime_end_ms] = (segment.personal_best_split_time.game_time.try(:total_seconds) || 0) * 1000
      split[:gametime_duration_ms] = [0, split[:gametime_end_ms] - run_object[:gametime_duration_ms]].max
      split[:gametime_start_ms] = split[:gametime_end_ms] - split[:gametime_duration_ms]

      split[:gametime_best_ms] = (segment.best_segment_time.game_time.try(:total_seconds) || 0) * 1000
      split[:gametime_skipped] = split[:gametime_duration_ms].zero?

      if split[:gametime_duration_ms].positive?
        split[:gametime_gold] = true if split[:gametime_duration_ms] <= split[:gametime_best_ms]
      end

      history_iterator = segment.segment_history.iter
      until (history_element = history_iterator.next).nil?
        history_element_time = history_element.time
        split[:history] << {
          attempt_number: history_element.index,
          gametime_duration_ms: (history_element_time.game_time.try(:total_seconds) || 0) * 1000,
          realtime_duration_ms: (history_element_time.real_time.try(:total_seconds) || 0) * 1000
        }
      end
      history_iterator.dispose

      run_object[:realtime_duration_ms] += split[:realtime_duration_ms] if split[:realtime_duration_ms].present?
      run_object[:gametime_duration_ms] += split[:gametime_duration_ms] if split[:gametime_duration_ms].present?
      run_object[:splits] << split
    end

    run.dispose
    add_default_proc!(run_object)
    run_object
  end

  def self.add_default_proc!(obj)
    obj.default_proc = ->(_hash, key) { raise KeyError, "#{key} not found" } if obj.respond_to?(:default_proc=)
    return unless obj.respond_to?(:each)

    obj.each do |value|
      add_default_proc!(value)
    end
  end

  private_class_method :add_default_proc!
end
