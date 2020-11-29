class SettingsController < ApplicationController
  def index
    redirect_to root_path if current_user.nil?
  end

  def update
    if user_params.reject { |k, v| v.blank? || k == 'password_confirmation' }.empty?
      redirect_back(fallback_location: settings_path, alert: 'Nothing was changed.')
      return
    end

    if !current_user.update(user_params)
      redirect_to(settings_path, alert: "Error: #{current_user.errors.full_messages.to_sentence}.")
      return
    end
    redirect_to(settings_path, notice: 'Updated! 👵➡🐱')
  end

  def destroy
    current_user.runs.destroy_all if params[:destroy_runs] == '1'
    if !current_user.destroy
      redirect_back(fallback_location: settings_path, alert: "Error: #{current_user.errors.full_messages.to_sentence}")
    end

    auth_session.invalidate!
    redirect_to(root_path, alert: 'Your account has been deleted. Go have fun outside :)')
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
