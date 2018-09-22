class TwitchUsersController < ApplicationController
  include Authenticatable

  def in
    auth = request.env['omniauth.auth']
    twitch_user = TwitchUser.from_auth(auth, current_user)
    if twitch_user.errors.any?
      redirect_to redirect_path, alert: "Couldn't sign in: #{twitch_user.errors.full_messages.to_sentence} :("
      return
    end

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
    self.current_user = user
    auth_session.persist!
  end

  def redirect_path
    request.env['omniauth.origin'] || cookies.delete('return_to') || root_path
>>>>>>> Google linking and sign in; username changes
  end
end
