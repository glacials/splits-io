require 'active_support/concern'
require 'twitch'

module TwitchUser
  extend ActiveSupport::Concern

  included do
    def sync_twitch_follows!
      ActiveRecord::Base.transaction do
        current_followed_users = User.where(twitch_id: Twitch::Follows.followed_ids(twitch_id))
        old_followed_users = twitch_followed_users

        (current_followed_users - old_followed_users).each do |u|
          TwitchUserFollow.create!(from_user: self, to_user: u)
        end

        (old_followed_users - current_followed_users).each do |u|
          TwitchUserFollow.find(from_user: self, to_user: u).destroy
        end

        update(twitch_user_follows_checked_at: Time.now.utc)
      end
    end

    def twitch_sync!
      body = Twitch::User.get(twitch_id)

      basic_info = JSON.parse(body)

      twitch_id = basic_info['_id']
      name = basic_info['name']
      avatar = basic_info['logo']
      display_name = basic_info['display_name']

      avatar = 'https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_150x150.png' if avatar.nil?

      uri = URI.parse(avatar).tap do |uri_tap|
        uri_tap.scheme = 'https'
      end

      update(
        twitch_id: twitch_id,
        name: name.downcase,
        avatar: uri.to_s,
        twitch_display_name: display_name
      )
    rescue RestClient::ResourceNotFound
      nil
    end
  end
end
