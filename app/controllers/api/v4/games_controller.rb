class Api::V4::GamesController < Api::V4::ApplicationController
  before_action :set_game, only: [:show]

  def index
    if params[:search].blank?
      render status: 400, json: {status: 400, message: 'You must supply a `search` term.'}
      return
    end
    @games = Game.search(params[:search]).includes(:categories)
    render json: @games, each_serializer: Api::V4::GameSerializer
  end

  def show
    render json: @game, serializer: Api::V4::GameSerializer
  end

  private

  def set_games
    @games = Game.search(params[:search])
  end
end
