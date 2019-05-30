class Races::BingosController < Races::ApplicationController
  def show
    render 'races/show'
  end

  private

  def set_race
    super(Bingo)
  end
end
