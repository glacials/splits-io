require 'active_support/concern'

module ForgetfulPersonsRun
  extend ActiveSupport::Concern

  included do
    # Returns segments, but with skipped segments rolled into the soonest future segment that wasn't realtime skipped.
    def realtime_collapsed_segments
      segments.reduce([]) do |segs, seg|
        if segs.last.try(:realtime_duration_ms) == 0
          skipped_seg = segs.last
          segs + [Segment.new(
            segs.pop.attributes.merge(
              name: "#{skipped_seg.name} + #{seg.name}",
              realtime_start_ms: skipped_seg.realtime_start_ms,
              realtime_end_ms: seg.realtime_end_ms,
              realtime_duration_ms: seg.realtime_duration_ms,
              gametime_start_ms: skipped_seg.gametime_start_ms,
              gametime_end_ms: skipped_seg.gametime_end_ms,
              gametime_duration_ms: seg.gametime_duration_ms,
              realtime_reduced: true
            )
          )]
        else
          segs + [seg]
        end
      end
    end

    # Returns segments, but with skipped segments rolled into the soonest future segment that wasn't gametime skipped.
    def gametime_collapsed_segments
      segments.reduce([]) do |segs, seg|
        if segs.last.try(:gametime_duration_ms) == 0
          skipped_seg = segs.last
          segs + [Segment.new(
            segs.pop.attributes.merge(
              name: "#{skipped_seg.name} + #{seg.name}",
              realtime_start_ms: skipped_seg.realtime_start_ms,
              realtime_end_ms: seg.realtime_end_ms,
              realtime_duration_ms: seg.realtime_duration_ms,
              gametime_start_ms: skipped_seg.gametime_start_ms,
              gametime_end_ms: skipped_seg.gametime_end_ms,
              gametime_duration_ms: seg.gametime_duration_ms,
              gametime_reduced: true
            )
          )]
        else
          segs + [seg]
        end
      end
    end

    def collapsed_segments(time_type)
      case time_type
      when Run::REAL
        realtime_collapsed_segments
      when Run::GAME
        gametime_collapsed_segments
      end
    end

    def realtime_skipped_splits
      segments.select(&:realtime_skipped?)
    end

    def gametime_skipped_splits
      segments.select(&:realtime_skipped?)
    end

    def skipped_splits(time_type)
      case time_type
      when Run::REAL
        realtime_skipped_splits
      when Run::GAME
        gametime_skipped_splits
      end
    end

    def realtime_has_skipped_splits?
      segments.any?(&:realtime_skipped?)
    end

    def gametime_has_skipped_splits?
      segments.any?(&:gametime_skipped?)
    end

    def has_skipped_splits?(time_type)
      case time_type
      when Run::REAL
        realtime_has_skipped_splits?
      when Run::GAME
        gametime_has_skipped_splits?
      end
    end
  end
end
