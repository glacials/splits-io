class Api::V4::Raceables::Messages::RandomizersController < Api::V4::Raceables::Messages::ApplicationController
  def index
    super
  end

  def create
    super
  end

  private

  def set_raceable
    super(Randomizer)
  end
end
