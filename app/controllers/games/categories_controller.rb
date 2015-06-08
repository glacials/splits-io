class Games::CategoriesController < ApplicationController
  before_action :set_game
  before_action :set_category

  def show
  end

  private

  def set_game
    @game = Game.find_by(shortname: params[:game_id])
    redirect_to game_path(params[:game_id]) if @game.nil?
  end

  def set_category
    @category = @game.categories.find_by(shortname: params[:id]) ||
                @game.categories.find_by(id: params[:id])
    redirect_to game_path(params[:game_id]) if @category.nil?
  end
end
