class SessionsController < ApplicationController
  before_action :ensure_access_granted, only: [:create]

  def new
    auth_uri = URI::parse('https://api.twitch.tv/kraken/oauth2/authorize')
    auth_uri.query = {
      response_type: 'code',
      client_id: ENV['TWITCH_CLIENT_ID'],
      redirect_uri: redirect_uri,
      scope: 'user_read'
    }.to_query
    redirect_to auth_uri.to_s
  end

  def create
    oauth_token = Twitch::User::OauthToken.find_by_authorization_code(params[:code], redirect_uri)
    twitch_user = Twitch::User.find_by_oauth_token(oauth_token)

    user = User.where(twitch_id: twitch_user['_id']).first_or_create
    user.load_from_twitch(twitch_user)
    user.twitch_token = oauth_token
    user.save

    self.current_user = user

    if cookies[:return_to]
      redirect_to cookies.delete(:return_to), notice: "Signed in as #{current_user.name}. o/"
    else
      redirect_to root_path, notice: "Signed in as #{current_user.name}. :P"
    end
  rescue SocketError, OpenSSL::SSL::SSLError, Errno::ECONNRESET => e
    redirect_to root_path,
      alert: "Couldn't communicate with Twitch to get your account info (#{e.class.to_s.demodulize}). Please try again."
  end

  def destroy
    auth_session.invalidate!
    redirect_to :back, notice: 'Logged out. (>-.-)>'
  end

  private

  def ensure_access_granted
    if params[:error] == 'access_denied'
      redirect_to root_path, notice: 'Woops, you denied access. That\'s okay, you can still upload runs anonymously.'
    end
  end


  def redirect_uri
    "http://#{request.host_with_port}/sessions/create"
  end
end
