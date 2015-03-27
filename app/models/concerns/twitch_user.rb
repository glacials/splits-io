require 'active_support/concern'

module TwitchUser
  extend ActiveSupport::Concern

  included do
    def load_from_twitch(twitch_response)
      assign_attributes(
        twitch_id: twitch_response['_id'],
        email: twitch_response['email'],
        name: twitch_response['name'],
        avatar: twitch_response['logo']
      )
    end

    def follows
      Rails.cache.fetch([:db, :follows, self]) do
        User.where(twitch_id: Twitch::Follows.find_by_user(self)).joins(:runs).group('users.id')
      end
    end
  end
end
