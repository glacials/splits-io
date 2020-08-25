class SessionsController < ApplicationController
  def new
    redirect_to(redirect_path) if current_user.present?
  end

  def in
    head :ok
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
