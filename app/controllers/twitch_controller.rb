class TwitchController < ApplicationController
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
    if params['error'] == 'access_denied'
      redirect_to root_path, notice: 'Woops, you denied access. That\'s okay, you can still upload runs anonymously.'
      return
    end

    token = HTTParty.post("https://api.twitch.tv/kraken/oauth2/token", query: post_params)['access_token']
    response = HTTParty.get("https://api.twitch.tv/kraken/user?oauth_token=#{token}")

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
  rescue HTTParty::ResponseError, SocketError => e
    redirect_to root_path,
      alert: "Couldn't communicate with Twitch to get your account info (#{e.class.to_s.demodulize}). Please try again."
  end

  private

  def redirect_uri
    "http://#{request.host_with_port}/signin/twitch/auth"
  end

  def post_params
    {
      client_id: ENV['TWITCH_CLIENT_ID'],
      client_secret: ENV['TWITCH_CLIENT_SECRET'],
      grant_type: 'authorization_code',
      redirect_uri: redirect_uri,
      code: params[:code]
    }
  end
end
