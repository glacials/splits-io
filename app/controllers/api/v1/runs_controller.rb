class Api::V1::RunsController < ApplicationController
  before_action :set_run, only: [:show]
  after_action :track

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
  rescue ActionController::ParameterMissing
    render status: 400, json: {
      status: 400,
      error: "No run file received. Make sure you're including a 'file' parameter in your request."
    }
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

  def search_params
    params.permit SAFE_PARAMS
  end

  def track
    @mixpanel.track(
      current_user.try(:id),
      [controller_path, action_name].join("#"),
      @run.try(:to_tracking_properties) || {}
    )
  end

  def run_url_helper
    Proc.new { |run| run_url(run) }
  end
end
