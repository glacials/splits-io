class Api::V3::RunsController < Api::V3::ApplicationController
  before_action :set_run, only: [:show, :destroy, :disown]
  before_action :verify_ownership!, only: [:destroy, :disown]

  def show
    render json: @run, serializer: Api::V3::RunWithSplitsSerializer
  end

  def create
    # TODO: Tokens, not cookies
    run_file = RunFile.for_file(params.require(:file))
    @run = Run.new(run_file: run_file, user: current_user, image_url: params[:image_url]).tap do |run|
      # TODO: Move this error handling into a before_action or a rescue
      unless run.parses?
        render status: 400, json: {
          status: 400,
          message: "Can't parse that file. We support WSplit 1.4.x, Nitrofski's WSplit 1.5.x fork, Time Split Tracker, SplitterZ, and LiveSplit >= 1.2."
        }
        return
      end
      run.save
    end
    render status: 201, location: api_v3_run_url(@run), json: {
      status: 201,
      message: "Run created.",
      id: @run.id.to_s(36),
      claim_token: @run.claim_token,
      uris: {
        api_uri: api_v3_run_url(@run),
        public_uri: run_url(@run),
        claim_uri: run_url(@run, claim_token: @run.claim_token)
      }
    }
    track! :upload
  rescue ActionController::ParameterMissing
    render status: 400, json: {
      status: 400,
      message: "No run file received. Make sure you're including a 'file' parameter in your request."
    }
  end

  # TODO: This method is not documented and thus is not officially supported by the API. It uses cookie authentication,
  # but the official release of it into the API should use token authentication.
  def destroy
    @run.destroy
    head 200
  end

  def disown
    @run.update_attributes(user: nil)
    head 200
  end

  private

  def set_run
    @run = Run.includes(:game, :category, :user).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {
      status: 404,
      message: "Run with id '#{params[:id]}' not found."
    }
  end

  def verify_ownership!
    unless @run.belongs_to?(current_user)
      render status: 401, json: {
        status: 401,
        message: "Run with id '#{params[:id]}' is not owned by you. You must supply a cookie proving your are the owner of this run in order to disown or delete it."
      }
      return false
    end
  end
end
