require 'active_support/concern'
require 'twitch'

module TwitchUser
  extend ActiveSupport::Concern

  def sync_twitch_follows!
    ActiveRecord::Base.transaction do
      current_followed_users = User.where(twitch_id: Twitch::Follows.followed_ids(twitch_id))

      # If TwitchUserFollow is changed to have child records or destroy callbacks, change this to destroy_all
      TwitchUserFollow.where(from_user: self, to_user: (twitch_followed_users - current_followed_users)).delete_all

      TwitchUserFollow.import!((current_followed_users - twitch_followed_users).map do |u|
        TwitchUserFollow.new(from_user: self, to_user: u)
      end)
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid => e
    update(twitch_user_follows_checked_at: nil)
    raise e
  end

  def twitch_sync!
    body = JSON.parse(Twitch::User.get(twitch_id))

    update(
      twitch_id:           body['_id'],
      name:                body['name'].downcase,
      avatar:              URI.parse(body['logo'] || default_avatar).tap { |uri| uri.scheme = 'https' }.to_s,
      twitch_display_name: body['display_name']
    )
  rescue RestClient::ResourceNotFound
    nil
  end

  private

  def default_avatar
    'https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_150x150.png'
  end
end
