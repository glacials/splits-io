class Api::V4::RunsController < Api::V4::ApplicationController
  before_action :set_run, only: [:parse, :show, :update, :destroy]
  before_action :verify_ownership!, only: [:update, :destroy]

  before_action :set_link_headers, if: -> { @run.present? }

  def parse
    if @run.parse(fast: true, convert: false).blank?
      head 500
      return
    end

    head 202
  end

  def show
    if params[:historic] == '1'
      @run.parse(fast: false)
      render json: @run, serializer: Api::V4::RunWithHistorySerializer
    else
      render json: @run, serializer: Api::V4::RunSerializer
    end
  end

  def create
    @run = Run.create(run_params)
    if !@run.persisted?
      render status: 400, json: {
        status: 400,
        message: "Couldn't reserve run. Please try again."
      }
      return
    end

    presigned_request = $s3_bucket.presigned_post(
      key: "splits/#{@run.id36}",
      content_length_range: 1..(100*1024*1024)
    )

    render status: 201, location: api_v4_run_url(@run), json: {
      status: 201,
      message: "Run reserved. Use the included presigned request to upload the file to S3, with an additional `file` field containing the run file.",
      id: @run.id36,
      claim_token: @run.claim_token,
      uris: {
        api_uri: api_v4_run_url(@run),
        public_uri: run_url(@run),
        claim_uri: run_url(@run, claim_token: @run.claim_token)
      },
      presigned_request: {
        method: 'POST',
        uri: presigned_request.url,
        fields: presigned_request.fields
      }
    }
  end

  def update
    if @run.update(run_params)
      head 204
    else
      head 500
    end
  end

  def destroy
    if @run.destroy
      head 204
    else
      head 500
    end
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

  def run_params
    params.permit(:srdc_id, :image_url)
  end
end
