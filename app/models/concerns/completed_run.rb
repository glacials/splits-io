require 'active_support/concern'

module CompletedRun
  extend ActiveSupport::Concern

  included do
    def splits
      parse[:splits] || []
    end

    def short?
      time < 20.minutes
    end

    def history
      parse[:history]
    end

    def best_known?
      category && time == category.best_known_run.try(:time)
    end

    def pb?
      user && category && self == user.pb_for(category)
    end

    def time
      read_attribute(:time).to_f
    end

    def has_golds?
      splits.all? { |split| split.best.duration }
    end
  end
end
