require 'active_support/concern'

module ForgetfulPersonsRun
  extend ActiveSupport::Concern

  included do
    # Returns segments, but with skipped segments rolled into the soonest future segment that wasn't skipped.
    def collapsed_segments
      segments.reduce([]) do |segs, seg|
        if segs.last.try(:duration_milliseconds) == 0
          skipped_seg = segs.last
          segs + [Segment.new(segs.pop.attributes.merge(
            duration_milliseconds: seg.duration_milliseconds,
            name: "#{skipped_seg.name} + #{seg.name}",
            start_milliseconds: skipped_seg.start_milliseconds,
            end_milliseconds: seg.end_milliseconds,
            reduced: true
          ))]
        else
          segs + [seg]
        end
      end
    end

    def skipped_splits
      segments.select do |segment|
        segment.skipped?
      end
    end

    def has_skipped_splits?
      segments.any? do |segment|
        segment.skipped?
      end
    end
  end
end
