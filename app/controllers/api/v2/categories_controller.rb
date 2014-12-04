class Api::V2::CategoriesController < Api::V2::ApplicationController
  def index
    render json: @records, each_serializer: Api::V2::CategorySerializer
  end

  def show
    render json: @record, serializer: Api::V2::CategorySerializer
  end

  private

  def safe_params
    [:id, :game_id]
  end

  def model
    Category
  end
end
