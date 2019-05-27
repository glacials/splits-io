class Races::ApplicationController < ApplicationController
  before_action :set_race,         only: [:show, :update]
  before_action :check_permission, only: [:show]
  before_action :set_race_gon,     only: [:show]

  def show
  end

  private

  def check_permission
    return unless @race.secret_visibility?
    return if     @race.joinable?(token: params[:join_token], user: current_user)

    render :unauthorized, status: :unauthorized
  end

  def set_race_gon
    return if @race.locked?

    token = @race.entrant_for_user(current_user).present? ? @race.join_token : nil
    gon.race = {
      id:         @race.id,
      type:       @race.type,
      join_token: token || params[:join_token]
    }
  end

  def message_params
    params.permit(:race, randomizer: {files: []})
  end
end
