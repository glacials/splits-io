require 'active_support/concern'

module UnparsedRun
  extend ActiveSupport::Concern

  included do
    def parses?(fast: true, convert: false)
      parse(fast: fast, convert: convert).present?
    end

    def parsed?
      return duration_milliseconds.present?
    end

    def parse(fast: true, convert: false)
      return @parse_cache[fast] if @parse_cache.try(:[], fast).present?
      return @parse_cache[false] if @parse_cache.try(:[], false).present?
      return @convert_cache if @convert_cache.present?

      if !convert
        if fast
          if !parsed?
            parse_into_activerecord
            if !parsed?
              return nil
            end
          end

          return {
            id: id36,
            timer: program,
            attempts: attempts,
            srdc_id: srdc_id,
            duration: duration_milliseconds / 1000,
            sum_of_best: sum_of_best_milliseconds / 1000,
            splits: segments,
          }
        end
      end

      # Convert flow below

      Run.programs.each do |timer|
        parse_result = timer::Parser.new.parse(file, fast: fast)
        next if parse_result.blank?

        parse_result[:timer] = timer.to_sym
        assign_attributes(
          program: parse_result[:timer],
          attempts: parse_result[:attempts],
          srdc_id: srdc_id || parse_result[:srdc_id].presence,
          time: parse_result[:splits].map { |split| split.duration }.sum.to_f,
          sum_of_best: parse_result[:splits].map.all? do |split|
            split.best.present?
          end && parse_result[:splits].map do |split|
            split.best
          end.sum.to_f
        )

        @convert_cache = parse_result
        @segments_cache = parse_result[:splits]

        return parse_result
      end

      {}
    end

    def parse_into_activerecord
      timer_used = nil
      parse_result = nil

      if file.nil?
        return false
      end

      Run.programs.each do |timer|
        parse_result = timer::Parser.new.parse(file, fast: false)

        if parse_result.present?
          timer_used = timer.to_sym
          break
        end
      end

      return false if timer_used.nil?

      if game.nil? || category.nil?
        populate_category(parse_result[:game], parse_result[:category])
      end

      segments = parse_result[:splits]

      if parse_result[:indexed_history].present?
        write_run_histories_to_dynamodb(parse_result[:indexed_history])
      end

      write_segments(segments)
      write_segment_histories(segments)

      duration_seconds = segments.map(&:duration).sum

      all_segments_have_bests = segments.map.all? do |segment|
        segment.best.present?
      end
      if !all_segments_have_bests
        sum_of_best_seconds = nil
        sum_of_best_milliseconds = nil
      else
        sum_of_best_seconds = segments.map(&:best).sum
        sum_of_best_milliseconds = sum_of_best_seconds * 1000
      end

      update(
        program: timer_used.to_s,
        attempts: parse_result[:attempts],
        srdc_id: srdc_id || parse_result[:srdc_id].presence,
        duration_milliseconds: duration_seconds * 1000,
        sum_of_best_milliseconds: sum_of_best_milliseconds,

        time: duration_seconds, # deprecated
        sum_of_best: sum_of_best_seconds # depreceated
      )
    end

    def write_segments(parsed_segments)
      segs = []

      parsed_segments.each.with_index do |parsed_segment, i|
        segs << Segment.new(
          run_id: id,
          segment_number: i,
          name: parsed_segment.name,
          duration_milliseconds: (parsed_segment.duration || 0) * 1000,
          start_milliseconds: (parsed_segment.start_time || 0) * 1000,
          end_milliseconds: (parsed_segment.finish_time || 0) * 1000,
          skipped: parsed_segment.skipped?,
          reduced: parsed_segment.reduced?,
          gold: parsed_segment.gold?,
          shortest_duration_milliseconds: (parsed_segment.best || 0) * 1000
        )
      end

      segments.import([
        :run_id,
        :segment_number,
        :name,
        :duration_milliseconds,
        :start_milliseconds,
        :end_milliseconds,
        :skipped,
        :reduced,
        :gold,
        :shortest_duration_milliseconds
      ], segs)
    end

    def write_segment_histories(segs)
      ids = segments.order(:segment_number).pluck(:id)
      histories = []

      segs.each.with_index do |seg, i|
        if seg.indexed_history.nil?
          return nil
        end

        seg.indexed_history.each do |history|
          histories << SegmentHistory.new(
            segment_id: ids[i],
            attempt_number: history[0].to_i,
            duration_milliseconds: history[1].nil? ? nil : history[1] * 1000
          )
        end
      end

      SegmentHistory.import(histories)
    end
  end
end
