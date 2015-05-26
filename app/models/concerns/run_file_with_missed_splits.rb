require 'active_support/concern'

module RunFileWithMissedSplits
  extend ActiveSupport::Concern

  included do
    # Takes care of skipped (e.g. missed) splits. If a run has no skipped splits, this method just returns `splits`.
    # If it does, the skipped splits are rolled into the soonest future split that wasn't skipped.
    def collapsed_segments
      segments.reduce([]) do |segments, segment|
        if segments.last.try(:duration) == 0
          skipped_split = segments.last
          segments + [Segment.new(segments.pop.to_h.merge(
            duration: split.duration,
            name: "#{skipped_split.name} + #{segment.name}",
            finish_time: segment.finish_time,
            reduced?: true
          ))]
        else
          segments + [segment]
        end
      end
    end

    def missed_splits
      segments.select(&:skipped?)
    end
  end
end
