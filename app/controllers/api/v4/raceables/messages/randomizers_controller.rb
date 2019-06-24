class Api::V4::Raceables::Messages::RandomizersController < Api::V4::Raceables::Messages::ApplicationController
  private

  def set_raceable
    super(Randomizer)
  end
end
