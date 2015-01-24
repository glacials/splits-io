class Games::Categories::Leaderboards::SumOfBestsController < ApplicationController
  before_action :set_game, only: [:index]
  before_action :set_category, only: [:index]

  def index
  end

  private

  def set_game
    @game = Game.find_by(shortname: params[:game_id]) || Game.find(params[:game_id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, file: "#{Rails.root}/public/404.html"
  end

  def set_category
    @category = @game.categories.find(params[:category_id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, file: "#{Rails.root}/public/404.html"
  end
end
