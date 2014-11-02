class GamesController < ApplicationController
  before_action :set_game

  def show
  end

  private

  def set_game
    @game = Game.find_by(shortname: params[:game_shortname])
    redirect_to search_path(params[:game_shortname]) if @game.nil?
  end
end
