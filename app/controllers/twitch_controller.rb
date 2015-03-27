class TwitchController < ApplicationController
  include HTTParty
  ssl_version :SSLv3

  def out
    auth_uri = URI::parse('https://api.twitch.tv/kraken/oauth2/authorize')
    auth_uri.query = {
      response_type: 'code',
      client_id: ENV['TWITCH_CLIENT_ID'],
      redirect_uri: redirect_uri,
      scope: 'user_read'
    }.to_query
    redirect_to auth_uri.to_s
  end

  def in
    if params[:error] == 'access_denied'
      redirect_to root_path, notice: 'Woops, you denied access. That\'s okay, you can still upload runs anonymously.'
      return
    end

    oauth_token = Twitch::User::OauthToken.find_by_authorization_code(params[:code], redirect_uri)
    twitch_user = Twitch::User.find_by_oauth_token(oauth_token)

    user = User.where(twitch_id: twitch_user['_id']).first_or_create
    user.load_from_twitch(twitch_user)
    user.twitch_token = oauth_token
    user.save

    sign_in(:user, user)
    user.remember_me!(100.years)

    flash = {notice: "Signed in as #{current_user.name} :D"}
    if cookies[:return_to]
      redirect_to cookies[:return_to], flash: flash
      cookies.delete(:return_to)
    else
      redirect_to root_path, flash: flash
    end
  rescue HTTParty::ResponseError, SocketError, OpenSSL::SSL::SSLError, Errno::ECONNRESET => e
    redirect_to root_path,
      alert: "Couldn't communicate with Twitch to get your account info (#{e.message}). Please try again."
  end

  private

  def redirect_uri
    "http://#{request.host_with_port}/signin/twitch/auth"
  end
end
