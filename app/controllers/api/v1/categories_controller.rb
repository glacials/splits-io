class Api::V1::CategoriesController < Api::V1::ApplicationController
  def index
    render json: @records
  end

  def show
    render json: @record
  end

  private

  def safe_params
    [:game_id]
  end

  def model
    Category
  end
end
