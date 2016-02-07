class Api::V4::RunsController < Api::V4::ApplicationController
  before_action :set_run, only: [:show, :update, :destroy, :disown, :runners, :splits]
  before_action :verify_ownership!, only: [:update, :destroy, :disown]

  before_action :set_link_headers, if: -> { @run.present? }

  def show
    if params[:historic] == '1'
      @run.parse(fast: false)
      render json: @run, serializer: Api::V4::RunWithHistorySerializer
    else
      render json: @run, serializer: Api::V4::RunSerializer
    end
  end

  def create
    run_file = RunFile.for_file(params.require(:file))
    @run = Run.new(run_params.merge(run_file: run_file)).tap do |run|
      # TODO: Move this error handling into a before_action or a rescue
      unless run.parses?
        render status: 400, json: {
          status: 400,
          message: "Can't parse that file. We support #{Run.programs.to_sentence}."
        }
        return
      end
      run.save
    end
    render status: 201, location: api_v4_run_url(@run), json: {
      status: 201,
      message: "Run created.",
      id: @run.id.to_s(36),
      claim_token: @run.claim_token,
      uris: {
        api_uri: api_v4_run_url(@run),
        public_uri: run_url(@run),
        claim_uri: run_url(@run, claim_token: @run.claim_token)
      }
    }
  rescue ActionController::ParameterMissing
    render status: 400, json: {
      status: 400,
      message: "No run file received. Make sure you're including a 'file' parameter in your request."
    }
  end

  def update
    @run.update(params.permit(:srdc_id, :image_url))
  end

  def destroy
    @run.destroy
    head 204
  end

  private

  def set_link_headers
    links = build_link_headers([
      {url: api_v4_run_url(@run), rel: 'api'},
      {url: run_url(@run), rel: 'site'}
    ])
    headers['Link'] = if headers['Link'].present?
       "#{headers['Link']}, #{links}"
    else
      links
    end
  end

  def verify_ownership!
    unless @run.claim_token.present? && params[:claim_token] == @run.claim_token
      render status: 401, json: {
        status: 401,
        message: "Invalid claim token."
      }
    end
  end

  def run_params
    params.permit(:srdc_id, :image_url)
  end
end
