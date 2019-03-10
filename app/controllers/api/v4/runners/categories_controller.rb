class Api::V4::Runners::CategoriesController < Api::V4::ApplicationController
  before_action :set_runner
  before_action :set_categories, only: [:index]

  def index
    categories = paginate @categories
    render json: Api::V4::CategoryBlueprint.render(categories, root: :categories)
  end

  private

  def set_categories
    @categories = @runner.categories
  end
end
