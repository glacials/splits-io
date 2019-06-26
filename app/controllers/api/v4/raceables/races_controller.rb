class Api::V4::Raceables::RacesController < Api::V4::Raceables::ApplicationController
  def index
    super(@raceables, Race)
  end

  def create
    race = Race.new(race_params)
    super(race)
  end

  def show
    super(@raceable)
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
