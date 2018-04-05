require 'active_support/concern'

module PadawanRun
  extend ActiveSupport::Concern

  included do
    def improvements_towards(better_run)
      improvements = {time_differences: [], missed_splits: []}

      return improvements if category != better_run.category
      return improvements if realtime_collapsed_segments.size != better_run.realtime_collapsed_segments.size

      realtime_collapsed_segments.each.with_index do |segment, i|
        if better_run.segments[i].realtime_duration_ms < segment.realtime_duration_ms && !segment.realtime_reduced?
          improvements[:time_differences] << {
            split: segment,
            time_difference: (segment.realtime_duration_ms - better_run.segments[i].realtime_duration_ms)
          }
        elsif segment.realtime_reduced?
          improvements[:missed_splits] << {
            split: segment
          }
        end
      end
      improvements
    end
  end
end
