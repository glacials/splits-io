class Api::V4::CategoriesController < Api::V4::ApplicationController
  before_action :set_category, only: [:show]

  def show
    render json: Api::V4::CategoryBlueprint.render(@category, root: :category)
  end
end
