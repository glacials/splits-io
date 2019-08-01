class RacesController < ApplicationController
  before_action :set_races,        only: [:index]
  before_action :set_race,         only: [:show, :update]
  before_action :check_permission, only: [:show]
  before_action :set_race_gon,     only: [:show]
  before_action :shorten_url,      only: [:show]

  def index
  end

  def show
    return unless @race.abandoned? && !@race.secret_visibility?

    flash.now.alert = 'This race is abandoned, it will not show up in listings! Readying, joining, or leaving will list it again.'
  end

  private

  def set_races
    @races = Race.active.not_secret_visibility
  end

  def check_permission
    return unless @race.secret_visibility?
    return if     @race.joinable?(token: race_params[:join_token], user: current_user)

    render :unauthorized, status: :unauthorized
  end

  def set_race_gon
    return if @race.locked?

    token = @race.entries.find_for(current_user).present? ? @race.join_token : nil
    gon.race = {
      id:         @race.id,
      join_token: token || race_params[:join_token]
    }
  end

  def race_params
    params.permit(:join_token, :attachment)
  end

  def set_race
    @race = Race.friendly_find!(params[:id])
  rescue ActiveRecord::RecordNotFound
    render 'application/not_found'
  end

  # shorten_url cuts the race ID down to its shortest unique form, and strips the join token param if it's not needed
  # (public race or the user already joined).
  def shorten_url
    if @race.visibility == :public || @race.entries.find_for(current_user).present?
      desired_fullpath = race_path(@race)
      redirect_to desired_fullpath if desired_fullpath != request.fullpath
      return
    end

    desired_fullpath = race_path(@race, race_params.to_hash.slice('join_token'))
    redirect_to desired_fullpath if desired_fullpath != request.fullpath
  end
end
