class SessionsController < ApplicationController
  def create
    twitch_id = request.env['omniauth.auth'].uid
    user = User.find_by(twitch_id: twitch_id) || User.new(twitch_id: twitch_id)

    user.update(
      name: request.env['omniauth.auth'].info.name,
      email: request.env['omniauth.auth'].info.email,
      avatar: request.env['omniauth.auth'].info.logo
    )

    if user.errors.present?
      redirect_to redirect_path, alert: "Error: #{user.errors.full_messages.join(', ')}."
      return
    end

    self.current_user = user
    auth_session.persist!
    redirect_to redirect_path, notice: "Signed in as #{current_user.name}. o/"
  end

  def destroy
    auth_session.invalidate!
    redirect_to :back, notice: 'Signed out. (>-.-)>'
  end

  def failure
    redirect_to redirect_path, alert: params[:message]
  end

  private

  def redirect_path
    cookies.delete(:return_to) || root_path
  end
end
