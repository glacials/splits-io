class Api::V4::Races::BingosController < Api::V4::Races::ApplicationController
  def index
    render json: Api::V4::RaceBlueprint.render(@races, view: :bingo)
  end

  def show
    render json: Api::V4::RaceBlueprint.render(@race, view: :bingo, chat: true)
  end

  private

  def set_races
    @races = Bingo.active
  end

  def set_race
    @race = Bingo.find(params[:race])
  rescue ActiveRecord::RecordNotFound
    render not_found(:bingo)
  end
end
