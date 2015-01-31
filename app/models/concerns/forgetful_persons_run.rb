require 'active_support/concern'

module ForgetfulPersonsRun
  extend ActiveSupport::Concern

  included do
    # Takes care of skipped (e.g. missed) splits. If a run has no skipped splits, this method just returns `splits`.
    # If it does, the skipped splits are rolled into the soonest future split that wasn't skipped.
    def reduced_splits
      splits.reduce([]) do |splits, split|
        if splits.last.try(:duration) == 0
          skipped_split = splits.last
          splits + [Split.new(splits.pop.to_h.merge(
            duration: split.duration,
            name: "#{skipped_split.name} + #{split.name}",
            finish_time: split.finish_time,
            reduced?: true
          ))]
        else
          splits + [split]
        end
      end
    end

    def has_skipped_splits?
      splits.any? { |split| split.skipped? }
    end
  end
end
