class Api::V4::GamesController < Api::V4::ApplicationController
  before_action :set_game, only: [:show]

  def show
    render json: @game, serializer: class.parent::GameSerializer
  end

  private

  def set_game
    @game = Game.includes(:categories).find_by(shortname: params[:id]) || Game.includes(:categories).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render not_found(:game, params[:id])
  end
end
