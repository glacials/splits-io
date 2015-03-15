class Api::V4::CategoriesController < Api::V4::ApplicationController
  before_action :set_game, only: [:show]
  before_action :set_category, only: [:show]

  def show
    paginate json: @category, serializer: class.parent::CategorySerializer
  end

  private

  def set_game
    @game = Game.includes(:categories).find_by(shortname: params[:game_id]) || Game.includes(:categories).find(params[:game_id])
  rescue ActiveRecord::RecordNotFound
    render not_found(:game, params[:game_id])
  end

  def set_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render not_found(:category, params[:id])
  end
end
