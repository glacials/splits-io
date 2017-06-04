require 'active_support/concern'

module PadawanRun
  extend ActiveSupport::Concern

  included do
    def improvements_towards(better_run)
      improvements = {time_differences: [], missed_splits: []}

      return improvements if category != better_run.category
      return improvements if collapsed_segments.size != better_run.collapsed_segments.size

      collapsed_segments.each.with_index do |segment, i|
        if (better_run.segments[i].duration_milliseconds) < segment.duration_milliseconds && !segment.reduced?
          improvements[:time_differences] << {split: segment, time_difference: (segment.duration_milliseconds - better_run.segments[i].duration_milliseconds)}
        elsif segment.reduced?
          improvements[:missed_splits] << {split: segment}
        end
      end
      improvements
    end
  end
end
