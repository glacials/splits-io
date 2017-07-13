require 'active_support/concern'

module CompletedRun
  extend ActiveSupport::Concern

  included do
    def splits
      segments
    end

    def realtime_shortest_segment
      realtime_collapsed_segments.min_by(&:realtime_duration_ms)
    end

    def realtime_longest_segment
      realtime_collapsed_segments.reject(&:realtime_reduced?).max_by(&:realtime_duration_ms)
    end

    def realtime_median_segment_duration_ms
      segments.pluck(:realtime_duration_ms).median.truncate
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
      segments.all?(&:realtime_shortest_duration_ms)
    end

    def realtime_total_playtime_ms
      SegmentHistory.where(segment: segments).sum(:realtime_duration_ms)
    end

    def gametime_total_playtime_ms
      SegmentHistory.where(segment: segments).sum(:gametime_duration_ms)
    end
  end
end
