class RivalriesController < ApplicationController
  def create
    if cannot?(:create, Rivalry)
      redirect_back(
        alert: 'You must be signed in to set a rival',
        fallback_location: root_path,
      )
      return
    end

    @rivalry = Rivalry.new(from_user: current_user)
    if !@rivalry.update(rivalry_params)
      redirect_back(
        alert: "Error setting rival: #{@rivalry.errors.full_messages.to_sentence}.",
        fallback_location: root_path,
      )
      return
    end

    redirect_back(notice: 'Rival set!', fallback_location: root_path)
  end

  def destroy
    @rivalry = current_user.rivalries.find_by(rivalry_params)
    if !@rivalry.destroy
      redirect_back(
        alert: "Error removing rival: #{@rivalry.errors.full_messages.to_sentence}",
        fallback_location: root_path,
      )
      return
    end

    redirect_back(notice: 'Rival removed!', fallback_location: root_path)
  end

  private

  def rivalry_params
    params.require(:rivalry).permit(:to_user_id, :category_id)
  end
end
