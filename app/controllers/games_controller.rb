class GamesController < ApplicationController
  before_action :set_game

  def show
    redirect_to game_category_path(@game, @game.categories.first)
  end

  private

  def set_game
    @game = Game.find_by(shortname: params[:id])
    redirect_to search_path(params[:game_shortname]) if @game.nil?
  end
end
