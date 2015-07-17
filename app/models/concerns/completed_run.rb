require 'active_support/concern'

module CompletedRun
  extend ActiveSupport::Concern

  included do
    def splits
      parse[:splits] || []
    end

    def missed_splits
      splits - reduced_splits
    end

    def shortest_segment
      reduced_splits.min_by(&:duration)
    end

    def longest_segment
      reduced_splits.max_by(&:duration)
    end

    def median_segment_duration
      sorted_segments = reduced_splits.map(&:duration).sort
      len = sorted_segments.size
      (sorted_segments[(len - 1) / 2] + sorted_segments[len / 2]) / 2.0
    end

    def short?
      time < 20.minutes
    end

    def history
      parse[:history]
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
      splits.all? { |split| split.best.duration }
    end
  end
end
