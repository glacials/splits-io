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

    def update_avatar!
      body = Twitch::User.find(name).get

      avatar = JSON.parse(body)['logo']
      return if avatar.blank?

      uri = URI.parse(avatar).tap do |uri|
        uri.scheme = 'https'
      end
      return if avatar == uri.to_s

      update(avatar: uri.to_s)
    rescue RestClient::ResourceNotFound
      nil
    end
  end
end
