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
      collapsed_segments.max_by(&:duration_milliseconds)
    end

    def median_segment_duration_milliseconds
      sorted_segments = collapsed_segments.map(&:duration_milliseconds).sort
      len = sorted_segments.size
      (sorted_segments[(len - 1) / 2] + sorted_segments[len / 2]) / 2.0
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
      splits.all? { |split| split.best }
    end

    def total_playtime_milliseconds
      SegmentHistory.where(segment_id: segments).map(&:duration_milliseconds).compact.sum
    end
  end
end
