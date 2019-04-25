require 'active_support/concern'

module ForgetfulPersonsRun
  extend ActiveSupport::Concern

  included do
    # Returns segments, but with skipped segments rolled into the soonest future segment that wasn't gametime skipped.
    def collapsed_segments(timing)
      segments.reduce([]) do |segs, seg|
        if segs.last.try(:duration_ms, timing) == 0
          skipped_seg = segs.last
          segs + [Segment.new(
            segs.pop.attributes.merge(
              name: "#{skipped_seg.name} + #{seg.name}",

              realtime_start_ms:    skipped_seg.start_ms(Run::REAL),
              realtime_end_ms:      seg.end_ms(Run::REAL),
              realtime_duration_ms: seg.duration_ms(Run::REAL),

              gametime_start_ms:    skipped_seg.start_ms(Run::GAME),
              gametime_end_ms:      skipped_seg.end_ms(Run::GAME),
              gametime_duration_ms: seg.duration_ms(Run::GAME),
            ).merge(
              case timing
              when Run::REAL
                {realtime_reduced: true}
              when Run::GAME
                {gametime_reduced: true}
              end
            )
          )]
        else
          segs + [seg]
        end
      end
    end

    def skipped_splits(timing)
      case timing
      when Run::REAL
        segments.select(&:realtime_skipped?)
      when Run::GAME
        segments.select(&:gametime_skipped?)
      end
    end

    def has_skipped_splits?(timing)
      case timing
      when Run::REAL
        segments.any?(&:realtime_skipped?)
      when Run::GAME
        segments.any?(&:gametime_skipped?)
      end
    end
  end
end
