class Raceables::BingosController < Raceables::ApplicationController
  def show
    render 'races/show'
  end

  private

  def set_race
    super(Bingo)
  end
end
