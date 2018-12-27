require 'twitch'

class TwitchUser < ApplicationRecord
  belongs_to :user

  include AvatarSource

  def self.from_auth(auth, current_user)
    twitch_user = TwitchUser.find_or_initialize_by(twitch_id: auth.uid)
    twitch_user.user = [
      current_user,
      twitch_user.user,
      User.joins(:google).find_by(google_users: {email: auth.info.email}),
      User.new(name: auth.info.name)
    ].compact.first

    unless twitch_user.user.save
      twitch_user.user.errors.full_messages.each do |error|
        twitch_user.errors.add(:user, error)
      end
      return twitch_user
    end

    twitch_user.assign_attributes(
      access_token: auth.credentials.token,
      name:         auth.info.nickname,
      display_name: auth.info.name,
      email:        auth.info.email,
      avatar:       auth.info.image || TwitchUser.default_avatar,
      url:          auth.info.urls.Twitch
    )
    twitch_user.save
    twitch_user
  end

  def sync_follows!
    ActiveRecord::Base.transaction do
      current_followed_users = User.joins(:twitch).where(
        twitch_users: {twitch_id: Twitch::Follows.followed_ids(twitch_id)}
      )

      # If TwitchUserFollow is changed to have child records or destroy callbacks, change this to destroy_all
      TwitchUserFollow.where(
        from_user: user,
        to_user: (user.twitch_follows - current_followed_users)
      ).delete_all

      TwitchUserFollow.import!((current_followed_users - user.twitch_follows).map do |u|
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
