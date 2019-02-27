class SpeedrunDotComUsersController < ApplicationController
  def create
    if cannot?(:create, SpeedrunDotComUser)
      unauthorized
      return
    end

    if SpeedrunDotComUser.from_api_key!(params[:speedrun_dot_com_user][:api_key].strip, user: current_user)
      redirect
      return
    end

    redirect_back(
      fallback_location: settings_path,
      alert:             "Couldn't link to Speedrun.com. Did you enter your API key correctly?"
    )
  end

  def destroy
    current_user.srdc.try(:destroy)
    redirect_back fallback_location: settings_path, notice: 'Speedrun.com account unlinked! 🚫🏆'
  end

  private

  def redirect
    if URI(request.referer).path == settings_path
      redirect_back(fallback_location: settings_path, notice: 'Speedrun.com account linked! 🏆')
      return
    end

    redirect_to("#{URI(request.referer).path}?srdc_submit=1")
  end
end
