class Api::V3::Games::RunsController < Api::V3::ApplicationController
  before_action :set_game, only: [:index]
  before_action :set_runs, only: [:index]

  def index
    runs = paginate @runs
    render json: RunBlueprint.render(runs, view: :api_v3, root: :runs)
  end

  private

  def set_game
    @game = Game.joins(:srdc).find_by(speedrun_dot_com_games: {shortname: params[:game_id]}) || Game.find(params[:game_id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: {status: 404, message: "Game with shortname or id '#{params[:game_id]}' not found."}
  end

  def set_runs
    @runs = @game.runs.includes(:game, :category, :user)
  end
end
