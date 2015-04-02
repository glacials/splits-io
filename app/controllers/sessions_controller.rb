class SessionsController < ApplicationController
  def create
    user = User.where(twitch_id: request.env['omniauth.auth'].uid).first_or_create(
      name: request.env['omniauth.auth'].info.name,
      email: request.env['omniauth.auth'].info.email,
      avatar: request.env['omniauth.auth'].info.logo
    )
    if user.errors.present?
      redirect_to cookies.delete(:return_to) || root_path, alert: "Error: #{user.errors.full_messages.join(', ')}."
      return
    end

    self.current_user = user
    redirect_to cookies.delete(:return_to) || root_path, notice: "Signed in as #{current_user.name}. o/"
  end

  def destroy
    auth_session.invalidate!
    redirect_to :back, notice: 'Logged out. (>-.-)>'
  end

  def failure
    redirect_to cookies.delete(:return_to) || root_path, alert: params[:message]
  end
end
