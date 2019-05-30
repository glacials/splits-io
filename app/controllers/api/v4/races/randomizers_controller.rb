class Api::V4::Races::RandomizersController < Api::V4::Races::ApplicationController
  def index
    render json: Api::V4::RaceBlueprint.render(@races, view: :randomizer)
  end

  def show
    render json: Api::V4::RaceBlueprint.render(@race, view: :randomizer, chat: true)
  end

  private

  def set_races
    @races = Randomizer.active
  end

  def set_race
    @race = Randomizer.find(params[:race])
  rescue ActiveRecord::RecordNotFound
    render not_found(:randomizer)
  end
end
