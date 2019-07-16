class Api::V4::GamesController < Api::V4::ApplicationController
  before_action :set_game, only: [:show]

  def index
    if params[:search].blank?
      @games = Game.joins(:srdc).includes(:categories)
    else
      @games = Game.search(params[:search]).includes(:categories)
    end
    render json: Api::V4::GameBlueprint.render(@games, root: :games, toplevel: :game)
  end

  def show
    render json: Api::V4::GameBlueprint.render(@game, root: :game, toplevel: :game)
  end

  private

  def set_games
    @games = Game.search(params[:search])
  end
end
