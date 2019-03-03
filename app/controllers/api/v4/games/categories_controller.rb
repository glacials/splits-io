class Api::V4::Games::CategoriesController < Api::V4::ApplicationController
  before_action :set_game, only: [:index]

  def index
    render json: CategoryBlueprint.render(@game.categories, view: :api_v4, root: :categories)
  end
end
