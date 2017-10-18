require 'active_support/concern'

module RivalUser
  extend ActiveSupport::Concern

  included do
    def rivalry_for(category)
      Rails.cache.fetch([:users, self, :categories, category, :rival], expires_in: 1.hour) do
        rivalries.for_category(category).first
      end
    end

    def rival_for(category)
      rivalry_for(category).try(:to_user)
    end
  end
end
