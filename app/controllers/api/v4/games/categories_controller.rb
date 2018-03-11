class Api::V4::Games::CategoriesController < Api::V4::ApplicationController
  before_action :set_game, only: [:index]

  def index
    render json: @game.categories, each_serializer: Api::V4::CategorySerializer
  end
end
