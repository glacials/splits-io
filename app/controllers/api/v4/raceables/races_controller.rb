class Api::V4::Raceables::RacesController < Api::V4::Raceables::ApplicationController
  def index
    render json: Api::V4::RaceBlueprint.render(@raceables, view: :race)
  end

  def create
    race = Race.new(race_params)
    super(race)
  end

  def show
    render json: Api::V4::RaceBlueprint.render(@raceable, root: :race, view: :race, chat: true)
  end

  def update
    render status: :not_acceptable, json: {
      status: 406,
      error:  'Cannot update races.'
    }
  end

  private

  def set_raceable
    super(Race)
  end

  def set_raceables
    super(Race)
  end

  def race_params
    params.permit(:category_id, :visibility, :notes)
  end
end
