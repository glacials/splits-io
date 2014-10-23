class Api::V1::CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  def index
    unless search_params.any? { |param| params.key?(param) }
      render status: 400, json: {
        status: 400,
        message: "You must supply one of the following parameters: #{search_params.join(", ")}"
      }
      return
    end
    @categories = Category.where params.permit(search_params)
    render json: @categories.pluck(:id)
  end

  def show
    render json: @category
  end

  private

  def set_category
    @category = Category.find params[:id]
  rescue ActiveRecord::RecordNotFound
    render({
      status: 404,
      json: {
        status: 404,
        message: "Category with id '#{params[:id]}' not found. If '#{params[:id]}' isn't a numeric ID, first use GET /api/v1/categories"
      }
    })
  end

  def search_params
    [:game_id]
  end
end
