require 'active_support/concern'

module PadawanRun
  extend ActiveSupport::Concern

  included do
    def improvements_towards(better_run)
      improvements = {time_differences: [], missed_splits: []}

      return improvements if category != better_run.category
      return improvements if collapsed_splits.size != better_run.collapsed_splits.size

      collapsed_splits.each.with_index do |split, i|
        if (better_run.splits[i].duration + 1) < split.duration && !split.reduced?
          improvements[:time_differences] << {split: split, time_difference: (split.duration - better_run.splits[i].duration).floor}
        elsif split.reduced?
          improvements[:missed_splits] << {split: split}
        end
      end
      improvements
    end
  end
end
