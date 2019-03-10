class Api::V3::GamesController < Api::V3::ApplicationController
  before_action :set_game, only: [:show]

  def index
    if params[:search].blank?
      render status: :bad_request, json: {status: 400, message: 'You must supply a `search` term.'}
      return
    end
    @games = Game.search(params[:search]).includes(:categories)
    render json: Api::V3::GameBlueprint.render(@games, root: :games)
  end

  def show
    render json: Api::V3::GameBlueprint.render(@game, root: :game, toplevel: :game)
  end

  private

  def set_game
    @game = Game.includes(:categories).joins(:srdc).find_by(speedrun_dot_com_games: {shortname: params[:id]})
    @game ||= Game.includes(:categories).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: {
      status:  404,
      message: "Game with shortname or id '#{params[:game_id]}' not found."
    }
  end
end
