class Games::Categories::Leaderboards::SumOfBestsController < ApplicationController
  before_action :set_game, only: [:index]
  before_action :set_category, only: [:index]

  def index
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
