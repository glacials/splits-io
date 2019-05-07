class RacesController < ApplicationController
  before_action :set_race, only: [:show]
  before_action :set_race_gon, only: [:show]

  def show
    render template: 'races/show'
  end

  private

  def set_race
    type = Raceable.race_from_type(params[:race_type])
    if type.nil?
      head 400
      return
    end

    @race = type.find(params[:race_id])
  rescue ActiveRecord::RecordNotFound
    render :not_found, status: :not_found
  end

  def set_race_gon
    gon.race = {
      id:   @race.id,
      type: params[:race_type]
    }
  end
end
