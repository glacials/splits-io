require 'active_support/concern'

module RivalUser
  extend ActiveSupport::Concern

  included do
    def rival_for(category)
      rivalries.for_category(category).map(&:to_user)
    end
  end
end
