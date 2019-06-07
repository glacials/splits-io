class Api::V4::Races::Messages::RacesController < Api::V4::Races::Messages::ApplicationController
  private

  def set_raceable
    super(Race)
  end
end
