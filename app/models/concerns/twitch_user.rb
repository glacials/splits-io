require 'active_support/concern'
require 'twitch'

module TwitchUser
  extend ActiveSupport::Concern

  included do
    def follows
      Rails.cache.fetch([:db, :follows, self]) do
        User.where(twitch_id: Twitch::Follows.find_by_user(self)).joins(:runs).group('users.id')
      end
    end

    def update_avatar
      user_json = JSON.parse(
        Twitch::User.find(name).get
      )
      if user_json && user_json['logo']
        update(avatar: user_json['logo'])
      end
    end
  end
end
