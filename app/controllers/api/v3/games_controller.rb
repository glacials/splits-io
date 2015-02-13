class Api::V3::GamesController < Api::V3::ApplicationController
  before_action :set_game, only: [:show]

  def show
    render json: @game, serializer: Api::V3::GameSerializer
  end

  private

  def set_game
    @game = Game.includes(:categories).find_by(shortname: params[:id]) || Game.includes(:categories).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {status: 404, message: "No game with shortname or id '#{params[:id]}' found."}
  end
end
