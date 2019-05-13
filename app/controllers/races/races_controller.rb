class Races::RacesController < Races::ApplicationController
  def show
    render 'races/show'
  end

  private

  def set_race
    @race = Race.find(params[:race])
  end
end
