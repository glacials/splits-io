require 'active_support/concern'

module CompletedRun
  extend ActiveSupport::Concern

  included do
    def splits
      segments
    end

    def shortest_segment
      collapsed_segments.min_by(&:duration_milliseconds)
    end

    def longest_segment
      collapsed_segments.reject(&:reduced?).max_by(&:duration_milliseconds)
    end

    def median_segment_duration_milliseconds
      segments.pluck(:duration_milliseconds).median.truncate
    end

    def short?
      time < 20.minutes
    end

    def history
      dynamodb_history
    end

    def best_known?
      category && time == category.best_known_run.try(:time)
    end

    def pb?
      user && category && self == user.pb_for(category)
    end

    def time
      read_attribute(:time).to_f
    end

    def has_golds?
      segments.all?(&:shortest_duration_milliseconds)
    end

    def total_playtime_milliseconds
      SegmentHistory.where(segment: segments).sum(:duration_milliseconds)
    end
  end
end
