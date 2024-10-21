require 'active_support/concern'

module ForgetfulPersonsRun
  extend ActiveSupport::Concern

  included do
    # Returns segments, but with skipped segments rolled into the soonest future segment that wasn't skipped. If the run
    # is not complete (i.e. the last segment and any # segments directly before it have nil durations), we don't
    # return that last stretch of segments at all.
    def collapsed_segments(timing)
      @collapsed_segments ||= begin
        in_progress_segments = segments.reverse.take_while { |segment| segment.duration(timing).nil? }
        segments[0..segments.count - 1 - in_progress_segments.count].reduce([]) do |segs, next_seg|
          if segs.any? && segs.last.try(:duration, timing).nil?
            skipped_seg = segs.last

            # We're about to modify this segment in memory for display purposes,
            # but we don't want to persist it to the database.
            # We also don't want to use Segment.new,
            # because its associations (e.g. segment.run) won't be cached so would cause duplicate queries.
            skipped_seg.readonly!

            skipped_seg.name = "#{skipped_seg.name} + #{next_seg.name}"

            skipped_seg.realtime_start_ms = skipped_seg.start(Run::REAL).to_ms
            skipped_seg.realtime_end_ms = next_seg.end(Run::REAL).to_ms
            skipped_seg.realtime_duration_ms = next_seg.duration(Run::REAL).to_ms
            skipped_seg.realtime_shortest_duration_ms = [skipped_seg, next_seg].map { |s| s.shortest_duration(Run::REAL).to_ms }.compact.sum(0)

            skipped_seg.gametime_start_ms = skipped_seg.start(Run::GAME).to_ms
            skipped_seg.gametime_end_ms = next_seg.end(Run::GAME).to_ms
            skipped_seg.gametime_duration_ms = next_seg.duration(Run::GAME).to_ms
            skipped_seg.gametime_shortest_duration_ms = [skipped_seg, next_seg].map { |s| s.shortest_duration(Run::GAME).to_ms }.compact.sum(0)

            case timing
            when Run::REAL
              skipped_seg.realtime_reduced = true
            when Run::GAME
              skipped_seg.gametime_reduced = true
            end

            segs
          else
            segs + [next_seg]
          end
        end.push(*in_progress_segments)
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
