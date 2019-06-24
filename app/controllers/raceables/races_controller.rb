class Raceables::RacesController < Raceables::ApplicationController
  def show
    render 'races/show'
  end

  private

  def set_race
    super(Race)
  end
end
