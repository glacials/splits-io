class TwitchUsersController < ApplicationController
  include Authenticatable

  def in
    twitch_user = TwitchUser.from_auth(request.env['omniauth.auth'], current_user)
    if twitch_user.errors.any?
      redirect_to redirect_path, alert: "Couldn't sign in: #{twitch_user.errors.full_messages.to_sentence} :("
      return
    end
    
    request.env['return_to'] = cookies['return_to']
    cookies.delete('return_to')

    if request.env['omniauth.origin'] == settings_url
      redirect_to settings_path, notice: 'Twitch account linked!'
      return
    end

    sign_in(twitch_user.user)
    redirect_to redirect_path, notice: "'Hoy!! o/ Signed in as #{current_user}."
  end

  def unlink
    current_user.twitch.try(:destroy)
    redirect_to settings_path, notice: 'Twitch account unlinked! 🙅🔗'
  end

  private

  def sign_in(user)
    create_auth_session(user)
    auth_session.persist!
  end

  def redirect_path
    if request.env['omniauth.origin'] == signin_url
      request.env['return_to']
    else
      request.env['omniauth.origin'] || root_path
    end
  end
end
