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
        size = 0
        file do |f|
          return false if f.nil?

          parse_result = Parser.parse(f.fileno)
          size = File.size(f)
        end

        return false if parse_result.nil?
        return false if parse_result[:splits].blank?

        timer_used = Run.program_from_attribute(:to_s, parse_result[:program]).to_sym

        default_timing = Run::REAL
        if parse_result[:realtime_duration_ms].zero? && parse_result[:gametime_duration_ms].positive?
          default_timing = Run::GAME
        end

        populate_category(parse_result[:game], parse_result[:category]) if game.nil? || category.nil?

        splits = parse_result[:splits]

        write_run_histories(parse_result[:history]) if parse_result[:history].present?

        write_segments(splits)
        write_segment_histories(splits)

        update(
          parsed_at:               Time.now.utc,
          program:                 timer_used.to_s,
          attempts:                parse_result[:attempts],
          srdc_id:                 srdc_id || parse_result[:metadata][:srdc_id],

          realtime_duration_ms:    parse_result[:realtime_duration_ms] || 0,
          realtime_sum_of_best_ms: parse_result[:realtime_sum_of_best_ms],

          gametime_duration_ms:    parse_result[:gametime_duration_ms] || 0,
          gametime_sum_of_best_ms: parse_result[:gametime_sum_of_best_ms],

          total_playtime_ms:       parse_result[:total_playtime_ms],
          default_timing:          default_timing,
          filesize_bytes:          size
        )

        HighlightSuggestion.from_run(self)
      end
    end

    def write_run_histories(histories)
      return nil if histories.nil?

      RunHistory.import(histories.map do |history|
        RunHistory.new(
          run_id: id,

          attempt_number:       history[:attempt_number],
          realtime_duration_ms: history[:realtime_duration_ms],
          gametime_duration_ms: history[:gametime_duration_ms],

          started_at: history[:started_at],
          ended_at:   history[:ended_at]
        )
      end)
    end

    def write_segments(parsed_segments)
      segs = []

      parsed_segments.each do |parsed_segment|
        segs << Segment.new(
          run_id:         id,
          segment_number: parsed_segment[:segment_number],
          name:           parsed_segment[:name],

          realtime_start_ms:             parsed_segment[:realtime_start_ms],
          realtime_end_ms:               parsed_segment[:realtime_end_ms],
          realtime_duration_ms:          parsed_segment[:realtime_duration_ms],
          realtime_shortest_duration_ms: parsed_segment[:realtime_best_ms],

          realtime_skipped: parsed_segment[:realtime_skipped],
          realtime_reduced: false,
          realtime_gold:    parsed_segment[:realtime_gold],

          gametime_start_ms:             parsed_segment[:gametime_start_ms],
          gametime_end_ms:               parsed_segment[:gametime_end_ms],
          gametime_duration_ms:          parsed_segment[:gametime_duration_ms],
          gametime_shortest_duration_ms: parsed_segment[:gametime_best_ms],

          gametime_skipped: parsed_segment[:gametime_skipped],
          gametime_reduced: false,
          gametime_gold:    parsed_segment[:gametime_gold]
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
        return nil if seg[:history].blank?

        seg[:history].each do |history|
          next unless history[:attempt_number].to_i.positive?

          histories << SegmentHistory.new(
            segment_id:           ids[i],
            attempt_number:       history[:attempt_number].to_i,
            realtime_duration_ms: history[:realtime_duration_ms],
            gametime_duration_ms: history[:gametime_duration_ms]
          )
        end
      end

      SegmentHistory.import(histories)
    end
  end
end
