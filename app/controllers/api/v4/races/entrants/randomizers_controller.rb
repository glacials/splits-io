class Api::V4::Races::Entrants::RandomizersController < Api::V4::Races::Entrants::ApplicationController
  def create
    super
  end

  def update
    super
  end

  def destroy
    super
  end

  private

  def set_raceable
    super(Randomizer)
  end
end
