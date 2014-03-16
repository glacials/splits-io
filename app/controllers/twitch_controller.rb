class TwitchController < ApplicationController

  def out
    redirect_to "https://api.twitch.tv/kraken/oauth2/authorize?response_type=code&client_id=#{client_id}&redirect_uri=#{redirect_uri}&scope=user_read"
  end

  def in
    post = { client_id:     client_id,
             client_secret: client_secret,
             grant_type:    'authorization_code',
             redirect_uri:  redirect_uri,
             code:          params[:code]
           }
    uri   = URI.parse('https://api.twitch.tv/kraken/oauth2/token')
    token = HTTParty.post(uri.to_s, query: post)['access_token']

    uri      = URI.parse("https://api.twitch.tv/kraken/user?oauth_token=#{token}")
    response = HTTParty.get(uri.to_s)

    user = User.find_by(twitch_id: response['_id']) || User.new
    user.twitch_token = token
    user.load_from_twitch(response)
    user.save

    sign_in(:user, user, remember_for: 100.years)

    if cookies[:return_to]
      redirect_to(cookies[:return_to])
      cookies.delete(:return_to)
    else
      redirect_to root_path
    end
  end

  private

  def client_id
    File.read('private/twitch/client_id').strip
  end

  def client_secret
    File.read('private/twitch/client_secret').strip
  end

  def redirect_uri
    "http://#{request.host_with_port}/login/twitch/auth"
  end

end
