class TwitchController < ApplicationController
  def out
    redirect_to "#{auth_uri}?response_type=code&client_id=#{client_id}&redirect_uri=#{redirect_uri}&scope=#{scopes}"
  end

  def in
    if params['error'] == 'access_denied'
      redirect_to root_path, flash: {
        icon: 'remove',
        notice: 'Woops, you denied access. That\'s okay, you can still upload runs anonymously.'
      }
      return
    end

    token = HTTParty.post("#{api_base_uri}/oauth2/token", query: post_params)['access_token']
    response = HTTParty.get("https://api.twitch.tv/kraken/user?oauth_token-#{token}")

    user = User.find_by(twitch_id: response['_id']) || User.new
    user.twitch_token = token
    user.load_from_twitch(response)
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
  end

  private

  def client_id
    ENV['TWITCH_CLIENT_ID']
  end

  def client_secret
    ENV['TWITCH_CLIENT_SECRET']
  end

  def redirect_uri
    "http://#{request.host_with_port}/signin/twitch/auth"
  end

  def api_base_uri
    'https://api.twitch.tv/kraken'
  end

  def auth_uri
    "#{api_base_uri}/oauth2/authorize"
  end

  def scopes
    'user_read'
  end

  def post_params
    {
      client_id:     client_id,
      client_secret: client_secret,
      grant_type:    'authorization_code',
      redirect_uri:  redirect_uri,
      code:          params[:code]
    }
  end
end
