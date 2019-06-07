class Api::V4::Races::Messages::RandomizersController < Api::V4::Races::Messages::ApplicationController
  private

  def set_raceable
    super(Randomizer)
  end
end
