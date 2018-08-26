class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']

    twitch_user = TwitchUser.find_or_initialize_by(twitch_id: auth.uid)
    twitch_user.user = User.new if twitch_user.user.blank?
    twitch_user.user.name = auth.info.nickname
    twitch_user.assign_attributes(
      access_token: auth.credentials.token,
      name:         auth.info.nickname,
      display_name: auth.info.name,
      email:        auth.info.email,
      avatar:       auth.info.image || TwitchUser.default_avatar
    )

    unless twitch_user.user.save
      redirect_to redirect_path, alert: "Error: #{user.errors.full_messages.join(', ')}."
      return
    end

    unless twitch_user.save
      redirect_to redirect_path, alert: "Error: #{twitch_user.errors.full_messages.join(', ')}."
      return
    end

    self.current_user = twitch_user.user
    auth_session.persist!
    redirect_to redirect_path, notice: "Signed in as #{current_user}. o/"
  end

  def destroy
    auth_session.invalidate!
    redirect_back fallback_location: root_path, notice: 'Signed out. (>-.-)>'
  end

  def failure
    redirect_to redirect_path, alert: "Error: #{params[:message]}"
  end

  private

  def redirect_path
    request.env['omniauth.origin'] || cookies.delete('return_to') || root_path
  end
end
