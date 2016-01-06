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

    def update_avatar!
      user_json = Twitch::User.find(name)
      return nil unless user_json.present?
      user_json = JSON.parse(user_json)
      if user_json['logo'].present? && avatar != user_json['logo']
        update(avatar: user_json['logo'])
      end
    end
  end
end
