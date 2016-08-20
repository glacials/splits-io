require 'active_support/concern'
require 'twitch'

module TwitchUser
  extend ActiveSupport::Concern

  included do
    def follows
      Rails.cache.fetch([:db, :follows, self]) do
        User.where(twitch_id: Twitch::Follows.followed_ids(self)).joins(:runs).group('users.id')
      end
    end

    def twitch_sync!
      body = Twitch::User.get(name)

      basic_info = JSON.parse(body)

      twitch_id = basic_info['_id']
      name = basic_info['name']
      avatar = basic_info['logo']

      uri = URI.parse(avatar).tap do |uri|
        uri.scheme = 'https'
      end

      update(
        twitch_id: twitch_id,
        name: name,
        avatar: uri.to_s
      )
    rescue RestClient::ResourceNotFound
      nil
    end
  end
end
