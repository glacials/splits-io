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

  def self.default_avatar
    'https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_150x150.png'
  end

  def videos
    Twitch::Videos.recent(twitch_id, type: :archive, token: access_token)
  end

  def followed_ids
    Twitch::Follows.followed_ids(twitch_id, token: access_token)
  end
end
