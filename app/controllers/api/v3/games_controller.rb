class Api::V3::GamesController < Api::V3::ApplicationController
  before_action :set_game, only: [:show]

  def index
    if params[:search].blank?
      render status: :bad_request, json: {status: 400, message: 'You must supply a `search` term.'}
      return
    end
    @games = Game.search(params[:search]).includes(:categories)
    render json: @games, each_serializer: Api::V3::GameSerializer, root: :games
  end

  def show
    render json: @game, serializer: Api::V3::GameSerializer, root: :game
  end

  private

  def set_game
    @game = Game.joins(:srdc).includes(:categories).find_by(speedrun_dot_com_games: {shortname: params[:id]}) || Game.includes(:categories).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: {status: 404, message: "No game with shortname or id '#{params[:id]}' found."}
  end
end
