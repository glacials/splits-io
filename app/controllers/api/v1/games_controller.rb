class Api::V1::GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def index
    unless search_params.any? { |param| params.key?(param) }
      render status: 400, json: {
        status: 400,
        message: "You must supply one of the following parameters: #{search_params.join(", ")}"
      }
      return
    end
    @games = Game.where params.permit(search_params)
    render json: @games.pluck(:id)
  end

  def show
    render json: @game
  end

  private

  def set_game
    @game = Game.find params[:id]
  rescue ActiveRecord::RecordNotFound
    render({
      status: 404,
      json: {
        status: 404,
        message: "Game with id '#{params[:id]}' not found. If '#{params[:id]}' is a shortname, try GET /api/v1/games?shortname=#{params[:id]}"
      }
    })
  end

  def search_params
    [:name, :shortname]
  end
end
