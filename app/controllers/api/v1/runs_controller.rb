class Api::V1::RunsController < ApplicationController
  before_action :set_run, only: [:show, :destroy, :disown]
  before_action :verify_ownership!, only: [:destroy, :disown]

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
    render json: @runs.map { |run| run.as_json(run_url_helper: run_url_helper) }
  end

  def show
    render json: @run.as_json(run_url_helper: run_url_helper)
  end

  def create
    # TODO: Tokens, not cookies
    @run = Run.new(file: params.require(:file).read, user: current_user, image_url: params[:image_url]).tap do |run|
      # TODO: Move this error handling into a before_action or a rescue
      unless run.parses?
        render status: 400, json: {
          status: 400,
          error: "Can't parse that file. We support WSplit 1.4.x, Nitrofski's WSplit 1.5.x fork, Time Split Tracker, SplitterZ, and LiveSplit >= 1.2."
        }
        return
      end
      run.category = Game.where(name: run.parse[:game]).first_or_create.categories.where(name: run.parse[:category]).first_or_create
      run.save
    end
    head 201, location: api_v1_run_url(@run)
    track! :upload
  rescue ActionController::ParameterMissing
    render status: 400, json: {
      status: 400,
      error: "No run file received. Make sure you're including a 'file' parameter in your request."
    }
  end

  # TODO: This method is not documented and thus is not officially supported by the API. It uses cookie authentication,
  # but the official release of it into the API should use token authentication.
  def destroy
    @run.destroy
    head 200
  end

  def disown
    @run.user = nil
    @run.save
    head 200
  end

  private

  def set_run
    @run = Run.find params[:id]
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {
      status: 404,
      error: "Run with id '#{params[:id]}' not found. If '#{params[:id]}' isn't a numeric id, first use GET #{api_v1_runs_url}"
    }
  end

  def verify_ownership!
    unless @run.belongs_to?(current_user)
      render status: 401, json: {
        status: 401,
        error: "Run with id '#{params[:id]}' is not owned by you. You must supply a cookie proving your are the owner of this run in order to delete it."
      }
      return false
    end
  end

  def search_params
    params.permit SAFE_PARAMS
  end

  def run_url_helper
    Proc.new { |run| run_url(run) }
  end
end
