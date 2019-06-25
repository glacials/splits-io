class Api::V4::Raceables::Messages::RacesController < Api::V4::Raceables::Messages::ApplicationController
  def show
    super
  end

  def create
    super
  end

  private

  def set_raceable
    super(Race)
  end
end
