class Races::BingosController < Races::ApplicationController
  def show
    render 'races/show'
  end

  private

  def set_race
    @race = Bingo.where('LEFT(id::text, ?) = ?', race_params[:race].length, race_params[:race]).order(created_at: :asc).first
  end
end
