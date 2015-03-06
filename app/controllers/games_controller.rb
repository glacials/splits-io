class GamesController < ApplicationController
  before_action :set_game, only: [:show]
  before_action :set_games, only: [:index]
  before_action :set_query, only: [:index]

  def index
  end

  def show
    @category = @game.categories.first
    render template: 'games/categories/show'
  end

  private

  def set_game
    @game = Game.find_by(shortname: params[:id])

    if @game.nil?
      redirect_to games_path(q: params[:id])
    end
  end

  def set_games
    @games = @query.present? ? Game.search(@query).includes(:categories, :runs) : []
  end

  def set_query
    @query = params[:q].strip if params[:q].present?
  end
end
