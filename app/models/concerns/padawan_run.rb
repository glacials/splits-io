require 'active_support/concern'

module PadawanRun
  extend ActiveSupport::Concern

  included do
    def improvements_towards(timing, better_run)
      improvements = {time_differences: [], missed_splits: []}

      return improvements if category != better_run.category
      return improvements if collapsed_segments(timing).size != better_run.collapsed_segments(timing).size

      collapsed_segments(timing).each.with_index do |segment, i|
        if better_run.segments[i].duration(timing) < segment.duration(timing) && !segment.reduced?(timing)
          improvements[:time_differences] << {
            split: segment,
            time_difference: (segment.duration(timing) - better_run.segments[i].duration(timing))
          }
        elsif segment.reduced?(timing)
          improvements[:missed_splits] << {
            split: segment
          }
        end
      end
      improvements
    end
  end
end
