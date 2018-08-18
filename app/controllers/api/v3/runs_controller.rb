class Api::V3::RunsController < Api::V3::ApplicationController
  before_action :set_run, only: %i[show destroy disown]
  before_action :verify_ownership!, only: %i[destroy disown]

  before_action only: [:create] do
    # If an OAuth token is supplied, use it (and fail if it's invalid). Otherwise, upload anonymously.
    doorkeeper_authorize! :upload_run if request.headers['Authorization'].present?
  end

  def show
    render json: @run, serializer: Api::V3::Detail::RunSerializer, root: :run
  end

  def create
    filename = SecureRandom.uuid

    @run = Run.create(
      user: current_user,
      image_url: params[:image_url],
      s3_filename: filename
    )

    $s3_bucket_internal.put_object(
      key: "splits/#{filename}",
      body: params.require(:file)
    )

    render status: :created, location: api_v3_run_url(@run), json: {
      status: 201,
      message: 'Run created.',
      id: @run.id36,
      claim_token: @run.claim_token,
      uris: {
        api_uri: api_v3_run_url(@run),
        public_uri: run_url(@run),
        claim_uri: run_url(@run, claim_token: @run.claim_token)
      }
    }
  rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordInvalid, PG::CharacterNotInRepertoire, ArgumentError
    render status: :bad_request, json: {
      status: 400,
      message: "Invalid run file received. Make sure you're including a 'file' parameter in your request."
    }
  end

  # TODO: These methods are not documented and thus is not officially supported by the API. It uses cookie
  # authentication, but the official release of it into the API should use token authentication.
  def destroy
    raise "Can't destroy run" unless @run.destroy

    head 200
  end

  def disown
    raise "Can't disown run" unless @run.update(user: nil)

    head 200
  end

  private

  def set_run
    @run = Run.includes(:game, :category, :user, :histories, segments: [:histories]).find(params[:id].to_i(36))
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: {
      status: 404,
      message: "Run with id '#{params[:id]}' not found."
    }
  end

  def verify_ownership!
    if cannot?(:edit, @run)
      render status: :unauthorized, json: {
        status: 401,
        message: "Run with id '#{params[:id]}' is not owned by you. You must supply a cookie proving your are the owner of this run in order to disown or delete it."
      }
    end
  end
end
