require 'active_support/concern'

module RunFileWithMissedSplits
  extend ActiveSupport::Concern

  included do
    # Takes care of skipped (e.g. missed) splits. If a run has no skipped splits, this method just returns `segments`.
    # If it does, the segments with skipped splits are rolled into the nearest future segment whose split was made.
    def collapsed_segments
      segments.reduce([]) do |segments, segment|
        if segments.last.try(:duration) == 0
          skipped_segment = segments.last
          segments + [Segment.new(segments.pop.to_h.merge(
            real_duration: segment.real_duration,
            name: "#{skipped_segment.name} + #{segment.name}",
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
