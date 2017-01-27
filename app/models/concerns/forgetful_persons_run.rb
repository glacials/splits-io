require 'active_support/concern'

module ForgetfulPersonsRun
  extend ActiveSupport::Concern

  included do
    # Returns segments, but with skipped segments rolled into the soonest future segment that wasn't skipped.
    def collapsed_splits
      segments = dynamodb_segments

      segments.reduce([]) do |splits, split|
        if splits.last.try(:duration) == 0
          skipped_split = splits.last
          splits + [Split.new(splits.pop.to_h.merge(
            duration: split.duration,
            name: "#{skipped_split.name} + #{split.name}",
            start_time: skipped_split.start_time,
            finish_time: split.finish_time,
            reduced?: true
          ))]
        else
          splits + [split]
        end
      end
    end

    def skipped_splits
      dynamodb_segments.select do |segment|
        segment.skipped?
      end
    end

    def has_skipped_splits?
      dynamodb_segments.any? do |segment|
        segment.skipped?
      end
    end
  end
end
