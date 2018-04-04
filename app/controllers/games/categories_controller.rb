class Games::CategoriesController < ApplicationController
  before_action :set_game
  before_action :set_category

  def show
  end

  private

  def set_game
    @game = Game.where(shortname: params[:game]).or(Game.where(id: params[:game])).first

    not_found if @game.nil?
  end

  def set_category
    @category = @game.categories.where(shortname: params[:category]).or(
      @game.categories.where(id: params[:category])
    ).first

    not_found if @category.nil?
  end
end
