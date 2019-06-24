class Api::V4::Raceables::Messages::RacesController < Api::V4::Raceables::Messages::ApplicationController
  private

  def set_raceable
    super(Race)
  end
end
