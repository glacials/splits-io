class GamesController < ApplicationController
  before_action :set_game

  def show
    @category = @game.categories.first
    render template: 'games/categories/show'
  end

  private

  def set_game
    @game = Game.find_by(shortname: params[:id])
    redirect_to search_path(params[:id]) if @game.nil?
  end
end
