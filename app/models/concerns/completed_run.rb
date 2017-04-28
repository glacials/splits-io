require 'active_support/concern'

module CompletedRun
  extend ActiveSupport::Concern

  included do
    def splits
      segments
    end

    def segments
      if @segments_cache.nil?
        @segments_cache = (dynamodb_segments || [])
      end
      return @segments_cache
    end

    def segments_with_history
      if @segments_with_history_cache.nil?
        @segments_with_history_cache = segments
        @segments_with_history_cache.each do |segment|
          segment.history = segment.dynamodb_history
        end
      end
      return @segments_with_history_cache
    end

    def shortest_segment
      collapsed_splits.min_by(&:duration)
    end

    def longest_segment
      collapsed_splits.max_by(&:duration)
    end

    def median_segment_duration
      sorted_segments = collapsed_splits.map(&:duration).sort
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

    def total_playtime
      time = 0
      return time unless program == "livesplit"
      segments_with_history.each do |segment|
        time += segment.history.sum { |h| h[:duration_seconds].nil? ? 0 : h[:duration_seconds] }
      end
      return time
    end
  end
end
