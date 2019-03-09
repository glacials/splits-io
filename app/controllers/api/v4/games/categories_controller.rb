class Api::V4::Games::CategoriesController < Api::V4::ApplicationController
  before_action :set_game, only: [:index]

  def index
    render json: Api::V4::CategoryBlueprint.render(@game.categories, root: :categories)
  end
end
