class Api::V4::RunsController < Api::V4::ApplicationController
  before_action :set_run, only: [:show, :update, :destroy]
  before_action :verify_ownership!, only: [:update, :destroy]

  before_action :find_accept_header, only: [:show]

  before_action :set_link_headers, if: -> { @run.present? }

  before_action only: [:create] do
    if current_user.nil? # If a cookie is supplied, use it because we're probably on the website.
      # If an OAuth token is supplied, use it (and fail if it's invalid). Otherwise, upload anonymously.
      if request.headers['Authorization'].present?
        doorkeeper_authorize! :upload_run
      end
    end
  end

  def show
    timer = Run.program_from_content_type(@accept_header)
    if timer.nil?
      if params[:historic] == '1'
        @run.parse(fast: false)
        render json: @run, serializer: Api::V4::RunWithHistorySerializer
      else
        render json: @run, serializer: Api::V4::RunSerializer
      end
    else
      rendered_run = render_run_to_string(timer)
      send_data(
        rendered_run,
        layout: false,
        type: "#{@accept_header}",
        disposition: 'inline',
        filename: "#{@run.filename(timer: timer)}"
      )
    end
  end

  def create
    filename = SecureRandom.uuid

    rp = run_params
    if rp.nil?
      rp = {}
    end

    rp = rp.merge(s3_filename: filename, user: current_user)

    @run = Run.create(rp)
    if !@run.persisted?
      render status: 400, json: {
        status: 400,
        message: "Couldn't reserve run. Please try again."
      }
      return
    end

    presigned_request = $s3_bucket_external.presigned_post(
      key: "splits/#{filename}",
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

  def find_accept_header
    @accept_header = request.headers.fetch('HTTP_ACCEPT', 'application/json').downcase
    @accept_header = 'application/json' if @accept_header.blank?
    @accept_header = 'application/json' if @accept_header.include?('text/html')
    @accept_header = "#{Run.program(@run.timer).content_type}" if @accept_header == 'application/original-timer'
    valid_accepts = Run.exportable_programs.map(&:content_type) << 'application/json'
    unless valid_accepts.include?(@accept_header)
      render status: 406, json: {
        status: 406,
        error: "Accept mime type #{@accept_header} not supported",
        valid_accepts: valid_accepts
      }
      return
    end
  end

  def render_run_to_string(timer)
    if timer == Run.program(@run.timer)
      @run.file
    else
      render_to_string(file: "runs/#{timer.to_sym}.html.erb", layout: false)
    end
  end

  def run_params
    permitted_params = params.permit(:srdc_id, :image_url)

    if permitted_params.nil?
      return {}
    end

    return permitted_params
  end
end
