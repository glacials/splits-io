require 'active_support/concern'

module RivalUser
  extend ActiveSupport::Concern

  included do
    def rival_for(category)
      Rails.cache.fetch([:users, self, :categories, category, :rival]) do
        rivalries.for_category(category).map(&:to_user)
      end
    end
  end
end
