class Api::V4::Runners::CategoriesController < Api::V4::ApplicationController
  before_action :set_runner
  before_action :set_categories, only: [:index]

  def index
    categories = paginate @categories
    render json: CategoryBlueprint.render(categories, view: :api_v4, root: :categories)
  end

  private

  def set_categories
    @categories = @runner.categories
  end
end
