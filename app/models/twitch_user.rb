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
      User.new(name: auth.info.name, email: auth.info.email)
    ].compact.first

    unless twitch_user.user.save
      twitch_user.user.errors.full_messages.each do |error|
        twitch_user.errors.add(:user, error)
      end
      return twitch_user
    end

    twitch_user.assign_attributes(
      access_token:  auth.credentials.token,
      refresh_token: auth.credentials.refresh_token,
      name:          auth.info.nickname,
      display_name:  auth.info.name,
      email:         auth.info.email,
      avatar:        auth.info.image || TwitchUser.default_avatar,
      url:           auth.info.urls.Twitch
    )
    twitch_user.save
    twitch_user
  end

  def self.default_avatar
    'https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_150x150.png'
  end

  def videos
    retries ||= 0
    Twitch::Videos.recent(twitch_id, type: :archive, token: access_token)
  rescue RestClient::Unauthorized
    refresh_tokens!
    retries += 1
    retry if retries < 2
  end

  def followed_ids
    retries ||= 0
    Twitch::Follows.followed_ids(twitch_id, token: access_token)
  rescue RestClient::Unauthorized
    refresh_tokens!
    retries += 1
    retry if retries < 2
  end

  # refresh_tokens! updates the access token and refresh token for this user with a new one from the Twitch API.
  def refresh_tokens!
    update(Twitch.new_tokens!(refresh_token))
  rescue RestClient::Unauthorized, RestClient::BadRequest
    # If the refresh got 401 Unauthorized, we were probably de-authorized from using the user's Twitch account. If it
    # got 400 Bad Request, we probably have a nil refresh token, perhaps because the authorization was created before we
    # started saving refresh tokens to the database.
    #
    # Ideally we'd destroy the TwitchUser here, but that may leave the user with no way to sign in. Instead, force a
    # sign out so we can get some fresh tokens. Until that happens we technically have no way to verify this Twitch user
    # and this Splits.io user are the same person, only that they once were in the past.
    #
    # Once we have linkless accounts, change this to destroy the TwitchUser.
    user.sessions.destroy_all
  end
end
