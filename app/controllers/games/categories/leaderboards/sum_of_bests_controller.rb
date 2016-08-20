class Games::Categories::Leaderboards::SumOfBestsController < ApplicationController
  before_action :set_game, only: [:index]
  before_action :set_category, only: [:index]

  def index
  end

  private

  def set_game
    @game = Game.where(shortname: params[:game_id]).or(Game.where(id: params[:game_id])).first

    if @game.nil?
      render status: 404, file: "#{Rails.root}/public/404.html"
    end
  end

  def set_category
    @category = @game.categories.where(shortname: params[:category_id]).or(
      @game.categories.where(id: params[:category_id])
    ).first

    if @category.nil?
      render status: 404, file: "#{Rails.root}/public/404.html"
    end
  end
end
