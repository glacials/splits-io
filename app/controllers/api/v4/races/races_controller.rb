class Api::V4::Races::RacesController < Api::V4::Races::ApplicationController
  def index
    render json: Api::V4::RaceBlueprint.render(@races, view: :race)
  end

  def show
    render json: Api::V4::RaceBlueprint.render(@race, view: :race, chat: true)
  end

  private

  def set_races
    @races = Race.active
  end

  def set_race
    @race = Race.find(params[:race])
  rescue ActiveRecord::RecordNotFound
    render not_found(:race)
  end
end
