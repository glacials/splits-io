class SessionsController < ApplicationController
  def create
    twitch_user = TwitchUser.from_auth(request.env['omniauth.auth'])
    if twitch_user.errors.any?
      redirect_to redirect_path, alert: "Couldn't sign in: #{twitch_user.errors.full_messages.to_sentence} :("
      return
    end

    sign_in(twitch_user.user)
    redirect_to redirect_path, notice: "'Hoy!! o/ Signed in as #{current_user}."
  end

  def destroy
    auth_session.invalidate!
    redirect_back fallback_location: root_path, notice: 'Signed out. (>-.-)>'
  end

  def failure
    redirect_to redirect_path, alert: "Error: #{params[:message]}"
  end

  private

  def sign_in(user)
    self.current_user = user
    auth_session.persist!
  end

  def redirect_path
    request.env['omniauth.origin'] || cookies.delete('return_to') || root_path
  end
end
