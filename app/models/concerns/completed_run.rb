require 'active_support/concern'

module CompletedRun
  extend ActiveSupport::Concern

  included do
    # duration returns the total duration of the run, from the beginning of the first segment to the end of the last
    # segment.
    def duration(timing = default_timing)
      return Duration.new(nil) if segments.any? && segments.last.duration(timing).nil?

      case timing
      when Run::REAL
        Duration.new(realtime_duration_ms)
      when Run::GAME
        Duration.new(gametime_duration_ms)
      end
    end

    # duration_ms is deprecated. Use duration instead, which returns a Duration type.
    def duration_ms(timing = default_timing)
      case timing
      when Run::REAL
        realtime_duration_ms
      when Run::GAME
        gametime_duration_ms
      end
    end

    # sum_of_best returns the sum of all segments' fastest recorded times by the runner. In an ideal world with no
    # variance or mistakes on hitting splits and no route changes that aren't also reflected in the splits, this time is
    # the theoretical fastest time the runner has proven they can achieve in a perfect run.
    def sum_of_best(timing = default_timing)
      case timing
      when Run::REAL
        Duration.new(realtime_sum_of_best_ms)
      when Run::GAME
        Duration.new(gametime_sum_of_best_ms)
      end
    end

    # sum_of_best_ms is deprecated. Use sum_of_best instead, which returns a Duration type.
    def sum_of_best_ms(timing = default_timing)
      case timing
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
      collapsed_segments(timing).reject do |segment|
        segment.reduced?(timing)
      end.min_by do |segment|
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

    def median_segment_duration(timing)
      case timing
      when Run::REAL
        Duration.new(segments.pluck(:realtime_duration_ms).extend(DescriptiveStatistics).median.truncate)
      when Run::GAME
        Duration.new(segments.pluck(:gametime_duration_ms).extend(DescriptiveStatistics).median.truncate)
      end
    end

    # median_segment_duration_ms is deprecated. Use median_segment_duration instead, which returns a Duration type.
    def median_segment_duration_ms(timing)
      case timing
      when Run::REAL
        segments.pluck(:realtime_duration_ms).extend(DescriptiveStatistics).median.truncate
      when Run::GAME
        segments.pluck(:gametime_duration_ms).extend(DescriptiveStatistics).median.truncate
      end
    end

    def short?(timing)
      return false if duration_ms(timing).nil?

      duration_ms(timing) < 20 * 60 * 1000
    end

    def best_known?(timing)
      return false if category.nil?

      best_run = category.best_known_run(timing)
      return false if best_run.nil?

      duration_ms(timing) == best_run.duration_ms(timing)
    end

    def pb?(timing)
      user && category && self == user.pb_for(timing, category)
    end

    def time
      self[:time].to_f
    end

    # has_golds? returns something truthy if the run includes fastest times recorded for every segment. If even one
    # segment is missing a fastest time, it returns something falsey.
    def has_golds?(timing)
      segments.all? do |segment|
        segment.shortest_duration_ms(timing)
      end
    end

    def completed?(timing)
      duration(timing).present? && duration(timing).positive?
    end

    # total_playtime returns the total amount of time logged in this game by this runner, according to the timer. This
    # includes all partial and complete runs.
    def total_playtime
      Duration.new(self[:total_playtime_ms] || SegmentHistory.where(segment: segments).sum(:realtime_duration_ms))
    end

    # total_playtime_ms is deprecated. Use total_playtime instead, which returns a Duration type.
    def total_playtime_ms
      self[:total_playtime_ms] || SegmentHistory.where(segment: segments).sum(:realtime_duration_ms)
    end
  end
end
