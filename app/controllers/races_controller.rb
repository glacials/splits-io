class RacesController < ApplicationController
  before_action :set_races, only: [:index]
  before_action :set_race, only: [:show, :update]
  before_action :check_permission, only: [:show]
  before_action :set_race_gon, only: [:show]
  before_action :shorten_url, only: [:show]

  def index
  end

  def show
    if params[:browsersource] == "1"
      render :browsersource_show
      return
    end

    return unless @race.abandoned? && !@race.secret_visibility?

    flash.now.alert = "This race is abandoned and will not show up in listings! Interacting with it will list it again."
  end

  def race_params
    params.permit(:join_token, :attachment, :browsersource)
  end

  helper_method :race_params

  private

  def set_races
    @races = Race.active.not_secret_visibility
  end

  def check_permission
    return unless @race.secret_visibility?
    return if @race.joinable?(token: race_params[:join_token], user: current_user)

    render :unauthorized, status: :unauthorized
  end

  def set_race_gon
    return if @race.locked?

    token = @race.entries.find_for(current_user).present? ? @race.join_token : nil
    gon.race = {
      id: @race.id,
      join_token: token || race_params[:join_token],
    }
  end

  def set_race
    @race = Race.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render "application/not_found"
  end

  # shorten_url cuts the race ID down to its shortest unique form, and strips the join token param if it's not needed
  # (public race or the user already joined).
  def shorten_url
    if @race.public_visibility? || @race.entries.find_for(current_user).present?
      desired_fullpath = race_path(@race, race_params.except(:join_token))
      redirect_to desired_fullpath if desired_fullpath != request.fullpath
      return
    end

    desired_fullpath = race_path(@race, race_params)
    redirect_to desired_fullpath if desired_fullpath != request.fullpath
  end
end
