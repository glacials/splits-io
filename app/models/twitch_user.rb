require 'twitch'

class TwitchUser < ApplicationRecord
  belongs_to :user

  def self.from_auth(auth)
    twitch_user = TwitchUser.find_or_initialize_by(twitch_id: auth.uid)

    twitch_user.user = User.new if twitch_user.user.blank?
    twitch_user.user.name = auth.info.nickname
    unless twitch_user.user.save
      twitch_user.errors.add(:user, twitch_user.user.errors.full_messages)
      return twitch_user
    end

    twitch_user.assign_attributes(
      access_token: auth.credentials.token,
      name:         auth.info.nickname,
      display_name: auth.info.name,
      email:        auth.info.email,
      avatar:       auth.info.image || TwitchUser.default_avatar
    )
    twitch_user.save
    twitch_user
  end

  def avatar
    URI.parse(self[:avatar]).tap do |uri|
      uri.scheme = 'https'
    end.to_s
  end

  def sync!
    body = JSON.parse(Twitch::User.get(twitch_id))

    update(
      twitch_id:    body['_id'],
      name:         body['name'].downcase,
      display_name: body['display_name'],
      avatar:       URI.parse(body['logo'] || self.class.default_avatar).tap { |uri| uri.scheme = 'https' }.to_s
    )
  rescue RestClient::ResourceNotFound
    nil
  end

  def sync_follows!
    ActiveRecord::Base.transaction do
      current_followed_users = User.joins(:twitch).where(twitch_user: {twitch_id: Twitch::Follows.followed_ids(twitch_id)})

      # If TwitchUserFollow is changed to have child records or destroy callbacks, change this to destroy_all
      TwitchUserFollow.where(
        from_user: user,
        to_user: (user.twitch_followed_users - current_followed_users)
      ).delete_all

      TwitchUserFollow.import!((current_followed_users - user.twitch_followed_users).map do |u|
        TwitchUserFollow.new(from_user: user, to_user: u)
      end)
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid => e
    update(follows_synced_at: Time.new(1970))
    raise e
  end

  def self.default_avatar
    'https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_150x150.png'
  end
end
