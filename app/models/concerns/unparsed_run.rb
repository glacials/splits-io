require 'active_support/concern'

module UnparsedRun
  extend ActiveSupport::Concern

  included do
    def parses?(fast: true, convert: false)
      parse(fast: fast, convert: convert).present? && timer.present?
    end

    def parsed?
      parsed_at.present?
    end

    def parse(fast: true, convert: false)
      return @parse_cache[fast] if @parse_cache.try(:[], fast).present?
      return @parse_cache[false] if @parse_cache.try(:[], false).present?
      return @convert_cache if @convert_cache.present?

      unless convert
        if fast
          unless parsed?
            parse_into_db
            return nil unless parsed?
          end

          return {
            id: id36,
            timer: program,
            attempts: attempts,
            srdc_id: srdc_id,
            duration: (realtime_duration_ms || 0) / 1000,
            sum_of_best: (realtime_sum_of_best_ms || 0) / 1000,
            splits: segments
          }
        end
      end

      # Convert flow below

      parse_result = Parser.parse(file, fast: fast)
      return {} if parse_result.nil?

      parse_result[:timer] = Run.program_from_attribute(:to_s, parse_result[:program]).to_sym
      assign_attributes(
        program: parse_result[:timer],
        attempts: parse_result[:attempts],
        srdc_id: srdc_id || parse_result[:srdc_id].presence,
        realtime_duration_s: parse_result[:splits].map { |split| split.realtime_duration }.sum.to_f,
        realtime_sum_of_best_s: parse_result[:splits].map.all? do |split|
          split.realtime_best.present?
        end && parse_result[:splits].map do |split|
          split.realtime_best
        end.sum.to_f
      )

      @convert_cache = parse_result
      @segments_cache = parse_result[:splits]

      parse_result
    end

    def parse_into_db
      with_lock do
        segments.delete_all
        histories.delete_all

        f = file
        return false if f.nil?

        parse_result = Parser.parse(f)
        return false if parse_result.nil?
        return false if parse_result[:splits].blank?
        timer_used = Run.program_from_attribute(:to_s, parse_result[:program]).to_sym

        if game.nil? || category.nil?
          populate_category(parse_result[:game], parse_result[:category])
        end

        segments = parse_result[:splits]

        if parse_result[:history].present?
          write_run_histories(parse_result[:history])
        end

        write_segments(segments)
        write_segment_histories(segments)

        all_segments_have_bests = segments.map.all? do |segment|
          segment.realtime_best.present?
        end

        sum_of_best_seconds = nil
        sum_of_best_milliseconds = nil
        if all_segments_have_bests
          sum_of_best_seconds = segments.map(&:realtime_best).sum

          if sum_of_best_seconds.present?
            sum_of_best_milliseconds = sum_of_best_seconds * 1000
          end
        end

        update(
          parsed_at: Time.now,
          program: timer_used.to_s,
          attempts: parse_result[:attempts],
          srdc_id: srdc_id || parse_result[:srdc_id].presence,

          realtime_duration_ms:    (segments.map(&:realtime_duration).sum || 0) * 1000,
          realtime_sum_of_best_ms: sum_of_best_milliseconds,
          realtime_duration_s:     (segments.map(&:realtime_duration).sum || 0), # deprecated
          realtime_sum_of_best_s:  sum_of_best_seconds, # deprecated

          gametime_duration_ms:    (segments.map(&:gametime_duration).sum || 0) * 1000,
          gametime_sum_of_best_ms: sum_of_best_milliseconds
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
        [
          :run_id,
          :segment_number,
          :name,

          :realtime_start_ms,
          :realtime_end_ms,
          :realtime_duration_ms,
          :realtime_shortest_duration_ms,
          :realtime_skipped,
          :realtime_reduced,
          :realtime_gold,

          :gametime_start_ms,
          :gametime_end_ms,
          :gametime_duration_ms,
          :gametime_shortest_duration_ms,
          :gametime_skipped,
          :gametime_reduced,
          :gametime_gold
        ],
        segs
      )
    end

    def write_segment_histories(segs)
      ids = segments.order(:segment_number).pluck(:id)
      histories = []

      segs.each.with_index do |seg, i|
        return nil if seg.indexed_history.nil?

        seg.indexed_history.each do |history|
          histories << SegmentHistory.new(
            segment_id: ids[i],
            attempt_number: history[0].to_i,
            realtime_duration_ms: history[1][:realtime].nil? ? nil : history[1][:realtime] * 1000
          )
        end
      end

      SegmentHistory.import(histories)
    end
  end
end
