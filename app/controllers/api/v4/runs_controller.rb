class Api::V4::RunsController < Api::V4::ApplicationController
  before_action :set_run, only: %i[show update destroy]
  before_action :verify_ownership!, only: [:update]

  before_action :find_accept_header, only: [:show]

  before_action :set_link_headers, if: -> { @run.present? }

  before_action only: [:create] do
    if current_user.nil? # If a cookie is supplied, use it because we're probably on the website.
      # If an OAuth token is supplied, use it (and fail if it's invalid). Otherwise, upload anonymously.
      if request.headers['Authorization'].present?
        doorkeeper_authorize! :upload_run
        self.current_user = User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end

  before_action only: [:destroy] do
    doorkeeper_authorize! :delete_run

    if doorkeeper_token.nil? || @run.user.nil? || doorkeeper_token.resource_owner_id != @run.user.id
      head :unauthorized
    end
  end

  def show
    timer = Run.program_from_attribute(:content_type, @accept_header)
    if timer.nil?
      options = { root: :run }
      options[:historic] = true if params[:historic] == '1'
      options[:segment_groups] = true if params[:segment_groups] == '1'
      render json: Api::V4::RunBlueprint.render(@run, options)
    else
      rendered_run = render_run_to_string(timer)
      send_data(
        rendered_run,
        layout: false,
        type: @accept_header.to_s,
        disposition: 'inline',
        filename: @run.filename(timer: timer).to_s
      )
    end
  end

  def create
    @run = Run.create(run_params.merge(s3_filename: SecureRandom.uuid, user: current_user))
    unless @run.persisted?
      render status: :bad_request, json: {
        status: 400,
        message: "Couldn't reserve run. Please try again."
      }
      return
    end

    presigned_request = $s3_bucket_external.presigned_post(
      key: "splits/#{@run.s3_filename}",
      content_length_range: 1..(25 * 1024 * 1024)
    )

    render status: :created, location: api_v4_run_url(@run), json: {
      status: 201,
      message: 'Run reserved. Use the included presigned request to upload the file to S3, with an additional `file` field containing the run file.',
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
    if request.headers['Authorization'].present?
      doorkeeper_authorize! :upload_run
      current_user = User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    if @run.destroy
      head 205
    else
      head 500
    end
  end

  private

  def set_link_headers
    links = build_link_headers([{url: api_v4_run_url(@run), rel: 'api'}, {url: run_url(@run), rel: 'site'}])
    headers['Link'] = if headers['Link'].present?
                        "#{headers['Link']}, #{links}"
                      else
                        links
                      end
  end

  def find_accept_header
    @accept_header = request.headers.fetch('HTTP_ACCEPT', 'application/json').downcase
    if @accept_header == 'application/original-timer'
      @accept_header = Run.program(@run.timer).content_type.to_s
      return
    end
    @accept_header = 'application/json' if ['', nil, '*/*'].include?(@accept_header)
    @accept_header = 'application/json' if @accept_header.include?('text/html')

    valid_accepts = Run.exportable_programs.map(&:content_type) << 'application/json'
    return if valid_accepts.include?(@accept_header)

    render status: :not_acceptable, json: {
      status:        406,
      error:         "Accept mime type #{@accept_header} not supported",
      valid_accepts: valid_accepts
    }
  end

  def render_run_to_string(timer)
    if timer == Run.program(@run.timer)
      @run.file
    else
      ApplicationController.render(
        "runs/exports/#{timer.to_sym}.html.erb",
        assigns: {run: @run},
        layout: false
      )
    end
  end

  def run_params
    permitted_params = params.permit(:srdc_id, :image_url)

    return {} if permitted_params.nil?

    permitted_params
  end
end
