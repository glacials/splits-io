class Api::V3::Games::CategoriesController < Api::V3::ApplicationController
  before_action :set_game, only: [:show]
  before_action :set_category, only: [:show]

  def show
    render json: @category, serializer: Api::V3::CategorySerializer, root: :category
  end

  private

  def set_game
    @game = Game.includes(:categories).find_by(shortname: params[:game_id]) || Game.includes(:categories).find(params[:game_id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: {status: 404, message: "No game with shortname or id '#{params[:game_id]}' found."}
  end

  def set_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: {status: 404, message: "No category with id '#{params[:id]}' found."}
  end
end
