class Games::CategoriesController < ApplicationController
  before_action :set_game
  before_action :set_category

  def show
  end

  private

  def set_game
    @game = Game.where(shortname: params[:game]).or(Game.where(id: params[:game])).first

    if @game.nil?
      not_found
    end
  end

  def set_category
    @category = @game.categories.where(shortname: params[:category]).or(
      @game.categories.where(id: params[:category])
    ).first

    if @category.nil?
      not_found
    end
  end
end
