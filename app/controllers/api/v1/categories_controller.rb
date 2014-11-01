class Api::V1::CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  SAFE_PARAMS = [:game_id]

  def index
    if search_params.empty?
      render status: 400, json: {
        status: 400,
        error: "You must supply one of the following parameters: #{SAFE_PARAMS.join(", ")}"
      }
      return
    end
    @categories = Category.where search_params
    render json: @categories
  end

  def show
    render json: @category
  end

  private

  def set_category
    @category = Category.find params[:id]
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {
      status: 404,
      error: "Category with id '#{params[:id]}' not found. If '#{params[:id]}' isn't a numeric ID, first use GET #{api_v1_categories_url}"
    }
  end

  def search_params
    params.permit SAFE_PARAMS
  end
end
