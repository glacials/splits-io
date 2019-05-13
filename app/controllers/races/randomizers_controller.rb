class Races::RandomizersController < Races::ApplicationController
  def show
    render 'races/show'
  end

  private

  def set_race
    @race = Randomizer.find(params[:race])
  end
end
