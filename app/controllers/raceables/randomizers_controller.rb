class Raceables::RandomizersController < Raceables::ApplicationController
  def show
    render 'races/show'
  end

  private

  def set_race
    super(Randomizer)
  end
end
