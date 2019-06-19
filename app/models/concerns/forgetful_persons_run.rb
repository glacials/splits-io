require 'active_support/concern'

module ForgetfulPersonsRun
  extend ActiveSupport::Concern

  included do
    # Returns segments, but with skipped segments rolled into the soonest future segment that wasn't skipped. If the run
    # is not complete (i.e. the last segment and any # segments directly before it have nil durations), we don't
    # return that last stretch of segments at all.
    def collapsed_segments(timing)
      in_progress_segments = segments.reverse.take_while { |segment| segment.duration(timing).nil? }
      segments[0..segments.count - 1 - in_progress_segments.count].reduce([]) do |segs, seg|
        if segs.any? && segs.last.try(:duration, timing).nil?
          skipped_seg = segs.last
          segs + [Segment.new(
            segs.pop.attributes.merge(
              name: "#{skipped_seg.name} + #{seg.name}",

              realtime_start_ms:             skipped_seg.start(Run::REAL).to_ms,
              realtime_end_ms:               seg.end(Run::REAL).to_ms,
              realtime_duration_ms:          seg.duration(Run::REAL).to_ms,
              realtime_shortest_duration_ms: [skipped_seg, seg].map { |s| s.shortest_duration(Run::REAL).to_ms }.compact.sum(0),

              gametime_start_ms:             skipped_seg.start(Run::GAME).to_ms,
              gametime_end_ms:               skipped_seg.end(Run::GAME).to_ms,
              gametime_duration_ms:          seg.duration(Run::GAME).to_ms,
              gametime_shortest_duration_ms: [skipped_seg, seg].map { |s| s.shortest_duration(Run::GAME).to_ms }.compact.sum(0),
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
      end.push(*in_progress_segments)
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
