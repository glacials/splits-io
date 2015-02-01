class Api::V3::GamesController < Api::V3::ApplicationController
  before_action :set_game, only: [:show]

  def show
    render json: @game, serializer: Api::V3::GameSerializer
  end

  private

  def set_game
    @game = Game.includes(:category).find_by(shortname: params[:id])
  end
end
