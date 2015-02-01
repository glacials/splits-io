class Api::V3::Games::RunsController < Api::V3::ApplicationController
  before_action :set_game, only: [:index]
  before_action :set_runs, only: [:index]

  def index
    paginate json: @runs, each_serializer: Api::V3::RunSerializer
  end

  private

  def set_game
    @game = Game.find_by(shortname: params[:game_id]) || Game.find(params[:game_id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {status: 404, message: "Game with shortname or id '#{params[:game_id]}' not found."}
  end

  def set_runs
    @runs = @game.runs.includes(:game).includes(:category).includes(:user)
  end
end
