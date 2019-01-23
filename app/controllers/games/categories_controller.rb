class Games::CategoriesController < ApplicationController
  before_action :set_game
  before_action :set_category

  def show
  end

  private

  def set_game
    @game = Game.joins(:srdc).find_by(speedrun_dot_com_games: {shortname: params[:game]}) || Game.find_by(id: params[:game])

    not_found if @game.nil?
  end

  def set_category
    @category = @game.categories.where(shortname: params[:category]).or(
      @game.categories.where(id: params[:category])
    ).first

    not_found if @category.nil?
    redirect_to game_category_path(@game, @category) if @game.srdc.try(:shortname).present? && params[:game] == @game.id.to_s
  end
end
