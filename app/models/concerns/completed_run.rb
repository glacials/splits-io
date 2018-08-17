require 'active_support/concern'

module CompletedRun
  extend ActiveSupport::Concern

  included do
    def duration_ms(time_type = default_time_type)
      case time_type
      when Run::REAL
        realtime_duration_ms
      when Run::GAME
        gametime_duration_ms
      end
    end

    def sum_of_best_ms(time_type = default_time_type)
      case time_type
      when Run::REAL
        realtime_sum_of_best_ms
      when Run::GAME
        gametime_sum_of_best_ms
      end
    end

    def splits
      segments
    end

    def shortest_segment(timing)
      realtime_collapsed_segments.min_by do |segment|
        segment.duration_ms(timing)
      end
    end

    def longest_segment(timing)
      collapsed_segments(timing).reject do |segment|
        segment.reduced?(timing)
      end.max_by do |segment|
        segment.duration_ms(timing)
      end
    end

    def median_segment_duration_ms(timing)
      case timing
      when Run::REAL
        segments.pluck(:realtime_duration_ms).median.truncate
      when Run::GAME
        segments.pluck(:gametime_duration_ms).median.truncate
      end
    end

    def short?
      time < 20.minutes
    end

    def best_known?(timing)
      return false if category.nil?

      best_run = category.best_known_run(timing)
      return false if best_run.nil?

      duration_ms(timing) == best_run.duration_ms(timing)
    end

    def pb?
      user && category && self == user.pb_for(category)
    end

    def time
      self[:time].to_f
    end

    def has_golds?(timing)
      segments.all? do |segment|
        segment.shortest_duration_ms(timing)
      end
    end

    def total_playtime_ms(timing)
      case timing
      when Run::REAL
        SegmentHistory.where(segment: segments).sum(:realtime_duration_ms)
      when Run::GAME
        SegmentHistory.where(segment: segments).sum(:gametime_duration_ms)
      end
    end

    def completed?(timing)
      duration_ms(timing).present? && duration_ms(timing).positive?
    end
  end
end
