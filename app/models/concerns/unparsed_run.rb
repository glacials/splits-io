require 'active_support/concern'

module UnparsedRun
  extend ActiveSupport::Concern

  included do
    def parsed?
      parsed_at.present?
    end

    def parse_into_db
      with_lock do
        segments.delete_all
        histories.delete_all

        parse_result = nil
        file do |f|
          return false if f.nil?

          parse_result = Parser.parse(f.fileno)
        end

        return false if parse_result.nil?
        return false if parse_result[:splits].blank?

        timer_used = Run.program_from_attribute(:to_s, parse_result[:program]).to_sym

        populate_category(parse_result[:game], parse_result[:category]) if game.nil? || category.nil?

        splits = parse_result[:splits]

        write_run_histories(parse_result[:history]) if parse_result[:history].present?

        segments = write_segments(splits)
        write_segment_histories(splits)

        all_splits_have_bests = splits.all? do |split|
          split.realtime_best.present?
        end

        realtime_best_times = nil
        gametime_best_times = nil

        if all_splits_have_bests
          realtime_best_times = extract_best_times(segments, Run::REAL)
          gametime_best_times = extract_best_times(segments, Run::GAME)
        end

        update(
          parsed_at: Time.now.utc,
          program: timer_used.to_s,
          attempts: parse_result[:attempts],
          srdc_id: srdc_id || parse_result[:srdc_id].presence,

          realtime_duration_ms:    (splits.map(&:realtime_duration).sum || 0) * 1000,
          realtime_sum_of_best_ms: realtime_best_times,
          realtime_duration_s:     (splits.map(&:realtime_duration).sum || 0), # deprecated
          realtime_sum_of_best_s:  realtime_best_times.try(:/, 1000), # deprecated

          gametime_duration_ms:    (splits.map(&:gametime_duration).sum || 0) * 1000,
          gametime_sum_of_best_ms: gametime_best_times
        )
      end
    end

    def write_run_histories(histories)
      return nil if histories.nil?

      RunHistory.import(histories.map do |history|
        RunHistory.new(
          run_id: id,
          attempt_number: history[:attempt_number],
          realtime_duration_ms: history[:realtime_duration_ms],
          gametime_duration_ms: history[:gametime_duration_ms]
        )
      end)
    end

    def write_segments(parsed_segments)
      segs = []

      parsed_segments.each.with_index do |parsed_segment, i|
        segs << Segment.new(
          run_id: id,
          segment_number: i,
          name: parsed_segment.name,

          realtime_start_ms:             (parsed_segment.realtime_start    || 0) * 1000,
          realtime_end_ms:               (parsed_segment.realtime_end      || 0) * 1000,
          realtime_duration_ms:          (parsed_segment.realtime_duration || 0) * 1000,
          realtime_shortest_duration_ms: (parsed_segment.realtime_best     || 0) * 1000,
          realtime_skipped: parsed_segment.realtime_skipped?,
          realtime_reduced: parsed_segment.realtime_reduced?,
          realtime_gold:    parsed_segment.realtime_gold?,

          gametime_start_ms:             (parsed_segment.gametime_start    || 0) * 1000,
          gametime_end_ms:               (parsed_segment.gametime_end      || 0) * 1000,
          gametime_duration_ms:          (parsed_segment.gametime_duration || 0) * 1000,
          gametime_shortest_duration_ms: (parsed_segment.gametime_best     || 0) * 1000,
          gametime_skipped: parsed_segment.gametime_skipped?,
          gametime_reduced: parsed_segment.gametime_reduced?,
          gametime_gold:    parsed_segment.gametime_gold?
        )
      end

      segments.import(
        %i[
          run_id
          segment_number
          name

          realtime_start_ms
          realtime_end_ms
          realtime_duration_ms
          realtime_shortest_duration_ms
          realtime_skipped
          realtime_reduced
          realtime_gold

          gametime_start_ms
          gametime_end_ms
          gametime_duration_ms
          gametime_shortest_duration_ms
          gametime_skipped
          gametime_reduced
          gametime_gold
        ],
        segs
      )

      segs
    end

    def write_segment_histories(segs)
      ids = segments.order(:segment_number).pluck(:id)
      histories = []

      segs.each.with_index do |seg, i|
        return nil if seg.indexed_history.nil?

        seg.indexed_history.each do |history|
          next unless history[0].to_i.positive?

          histories << SegmentHistory.new(
            segment_id: ids[i],
            attempt_number: history[0].to_i,
            realtime_duration_ms: history[1][:realtime].nil? ? nil : history[1][:realtime] * 1000,
            gametime_duration_ms: history[1][:gametime].nil? ? nil : history[1][:gametime] * 1000
          )
        end
      end

      SegmentHistory.import(histories)
    end

    def extract_best_times(segments, timing)
      segments.map { |segment| segment.shortest_duration_ms(timing) }.sum
    end
  end
end
