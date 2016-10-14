class Api::V3::RunsController < Api::V3::ApplicationController
  before_action :set_run, only: [:show, :destroy, :disown]
  before_action :verify_ownership!, only: [:destroy, :disown]

  def show
    render json: @run, serializer: Api::V3::Detail::RunSerializer, root: :run
  end

  def create
    @run = Run.create(
      user: current_user,
      image_url: params[:image_url]
    )

    $s3_bucket.put_object(
      key: "splits/#{@run.id}",
      body: params.require(:file)
    )

    render status: 201, location: api_v3_run_url(@run), json: {
      status: 201,
      message: "Run created.",
      id: @run.id,
      claim_token: @run.claim_token,
      uris: {
        api_uri: api_v3_run_url(@run),
        public_uri: run_url(@run),
        claim_uri: run_url(@run, claim_token: @run.claim_token)
      }
    }
  rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordInvalid, PG::CharacterNotInRepertoire, ArgumentError
    render status: 400, json: {
      status: 400,
      message: "Invalid run file received. Make sure you're including a 'file' parameter in your request."
    }
  end

  # TODO: These methods are not documented and thus is not officially supported by the API. It uses cookie
  # authentication, but the official release of it into the API should use token authentication.
  def destroy
    if !@run.destroy
      raise "Can't destroy run"
      return
    end

    head 200
  end

  def disown
    if !@run.update(user: nil)
      raise "Can't disown run"
      return
    end

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
    if cannot?(:edit, @run)
      render status: 401, json: {
        status: 401,
        message: "Run with id '#{params[:id]}' is not owned by you. You must supply a cookie proving your are the owner of this run in order to disown or delete it."
      }
      return false
    end
  end
end
