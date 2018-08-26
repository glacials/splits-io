require 'twitch'

class TwitchUser < ApplicationRecord
  belongs_to :user

  def avatar
    URI.parse(read_attribute(:avatar)).tap do |uri|
      uri.scheme = 'https'
    end.to_s
  end

  def sync!
    body = JSON.parse(Twitch::User.get(twitch_id))

    update(
      twitch_id:    body['_id'],
      name:         body['name'].downcase,
      display_name: body['display_name'],
      avatar:       URI.parse(body['logo'] || default_avatar).tap { |uri| uri.scheme = 'https' }.to_s
    )
  rescue RestClient::ResourceNotFound
    nil
  end

  def sync_follows!
    ActiveRecord::Base.transaction do
      current_followed_users = User.where(twitch_id: Twitch::Follows.followed_ids(twitch_id))

      # If TwitchUserFollow is changed to have child records or destroy callbacks, change this to destroy_all
      TwitchUserFollow.where(from_user: user, to_user: (twitch_followed_users - current_followed_users)).delete_all

      TwitchUserFollow.import!((current_followed_users - twitch_followed_users).map do |u|
        TwitchUserFollow.new(from_user: user, to_user: u)
      end)
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid => e
    update(follows_synced_at: nil)
    raise e
  end

  private

  def default_avatar
    'https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_150x150.png'
  end
end
