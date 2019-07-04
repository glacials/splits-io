class RacesController < ApplicationController
  before_action :set_race,         only: [:show, :update]
  before_action :check_permission, only: [:show]
  before_action :set_race_gon,     only: [:show]
  before_action :shorten_url,      only: [:show]

  def show
  end

  private

  def check_permission
    return unless @race.secret_visibility?
    return if     @race.joinable?(token: race_params[:join_token], user: current_user)

    render :unauthorized, status: :unauthorized
  end

  def set_race_gon
    return if @race.locked?

    token = @race.entry_for_user(current_user).present? ? @race.join_token : nil
    gon.race = {
      id:         @race.id,
      join_token: token || race_params[:join_token]
    }
  end

  def race_params
    params.permit(:race, :join_token, :attachment)
  end

  def set_race
    @race = Race.where(
      'LEFT(id::text, ?) = ?',
      race_params[:race].length,
      race_params[:race]
    ).order(created_at: :asc).first

    render 'application/not_found' if @race.nil?
  end

  # shorten_url cuts the race ID down to its shortest unique form, and strips the join token param if it's not needed
  # (public race or the user already joined).
  def shorten_url
    if @race.visibility == :public || @race.entry_for_user(current_user).present?
      desired_fullpath = race_path(@race)
      redirect_to desired_fullpath if desired_fullpath != request.fullpath
      return
    end

    desired_fullpath = race_path(@race, race_params.to_hash.slice('join_token'))
    redirect_to desired_fullpath if desired_fullpath != request.fullpath
  end
end
