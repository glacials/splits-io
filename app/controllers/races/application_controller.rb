class Races::ApplicationController < ApplicationController
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

    token = @race.entrant_for_user(current_user).present? ? @race.join_token : nil
    gon.race = {
      id:         @race.id,
      type:       @race.type,
      join_token: token || race_params[:join_token]
    }
  end

  private

  def race_params
    params.permit(:race, :join_token, :attachment)
  end

  # set_race should be called from controllers that extend this one.
  def set_race(klass)
    @race = klass.where(
      'LEFT(id::text, ?) = ?',
      race_params[:race].length,
      race_params[:race]
    ).order(created_at: :asc).first

    render 'application/not_found' if @race.nil?
  end

  def shorten_url
    return if request.path == polymorphic_path(@race)

    redirect_to polymorphic_path(@race)
  end
end
