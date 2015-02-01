class Api::V2::RunsController < Api::V2::ApplicationController
  before_action :verify_ownership!, only: [:destroy, :disown]

  def index
    paginate(
      json: @records.includes(:game).includes(:category).includes(:user),
      each_serializer: Api::V2::RunSerializer
    )
  end

  def show
    render json: @record, serializer: Api::V2::RunSerializer
  end

  def create
    # TODO: Tokens, not cookies
    @record = Run.new(file: params.require(:file).read, user: current_user, image_url: params[:image_url]).tap do |run|
      # TODO: Move this error handling into a before_action or a rescue
      unless run.parses?
        render status: 400, json: {
          status: 400,
          error: "Can't parse that file. We support WSplit 1.4.x, Nitrofski's WSplit 1.5.x fork, Time Split Tracker, SplitterZ, and LiveSplit >= 1.2."
        }
        return
      end
      run.save
    end
    head 201, location: api_v2_run_url(@record)
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
    @record.destroy
    head 200
  end

  def disown
    @record.user = nil
    @record.save
    head 200
  end

  private

  def verify_ownership!
    unless @record.belongs_to?(current_user)
      render status: 401, json: {
        status: 401,
        error: "Run with id '#{params[:id]}' is not owned by you. You must supply a cookie proving your are the owner of this run in order to delete it."
      }
      return false
    end
  end

  def run_url_helper
    Proc.new { |run| run_url(run) }
  end

  def safe_params
    [:id, :category_id, :user_id]
  end

  def model
    Run
  end
end
