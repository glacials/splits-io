class Api::V4::Runners::CategoriesController < Api::V4::ApplicationController
  before_action :set_runner
  before_action :set_categories, only: [:index]

  def index
    paginate json: @categories, each_serializer: Api::V4::CategorySerializer
  end

  private

  def set_categories
    @categories = @runner.categories
  end
end
