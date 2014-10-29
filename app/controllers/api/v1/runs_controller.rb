class Api::V1::RunsController < ApplicationController
  before_action :set_run, only: [:show]

  SAFE_PARAMS = [:category_id, :user_id]

  def index
    if search_params.empty?
      render status: 400, json: {
        status: 400,
        message: "You must supply one of the following parameters: #{SAFE_PARAMS.join(", ")}"
      }
      return
    end
    @runs = Run.where search_params
    render json: @runs
  end

  def show
    render json: @run.as_json.merge(url: run_url(@run))
  end

  private

  def set_run
    @run = Run.find params[:id]
  rescue ActiveRecord::RecordNotFound
    render({
      status: 404,
      json: {
        status: 404,
        message: "Run with id '#{params[:id]}' not found. If '#{params[:id]}' isn't a numeric id, first use GET /api/v1/runs"
      }
    })
  end

  def search_params
    params.permit SAFE_PARAMS
  end
end
