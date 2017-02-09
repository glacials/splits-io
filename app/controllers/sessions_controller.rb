class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']

    twitch_id = auth.uid
    user = User.find_by(twitch_id: twitch_id) || User.new(twitch_id: twitch_id)

    user.update(
      name: auth.info.nickname,
      twitch_display_name: auth.info.name,
      email: auth.info.email,
      avatar: auth.info.image,
      twitch_token: auth.credentials.token
    )

    if user.errors.present?
      redirect_to redirect_path, alert: "Error: #{user.errors.full_messages.join(', ')}."
      return
    end

    self.current_user = user
    auth_session.persist!
    redirect_to redirect_path, notice: "Signed in as #{current_user}. o/"
  end

  def destroy
    auth_session.invalidate!
    redirect_to :back, notice: 'Signed out. (>-.-)>'
  end

  def failure
    redirect_to redirect_path, alert: "Error: #{params[:message]}"
  end

  private

  def redirect_path
    cookies.delete(:return_to) || root_path
  end
end
