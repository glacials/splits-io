class Api::V4::CategoriesController < Api::V4::ApplicationController
  before_action :set_category, only: [:show]

  def show
    render json: CategoryBlueprint.render(@category, view: :api_v4, root: :category)
  end
end
