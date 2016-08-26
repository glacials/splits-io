class Api::V4::CategoriesController < Api::V4::ApplicationController
  before_action :set_category, only: [:show]

  def show
    render json: @category, serializer: Api::V4::CategorySerializer
  end
end
