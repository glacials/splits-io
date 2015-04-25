require 'active_support/concern'

module TwitchUser
  extend ActiveSupport::Concern

  included do
    def follows
      Rails.cache.fetch([:db, :follows, self]) do
        User.where(twitch_id: ::Twitch::Follows.find_by_user(self)).joins(:runs).group('users.id')
      end
    end
  end
end
