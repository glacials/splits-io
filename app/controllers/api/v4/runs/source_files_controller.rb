class Api::V4::Runs::SourceFilesController < Api::V4::ApplicationController
  before_action :set_run, only: [:show, :update]
  before_action only: [:update] do
    # If an OAuth token is supplied, use it (and fail if it's invalid).
    doorkeeper_authorize! :upload_run
    self.current_user = User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def show
    render(
      status: :see_other,
      location: $s3_bucket_internal.object("splits/#{@run.s3_filename}").presigned_url(
        :get,
        response_content_disposition: "attachment; filename=\"#{@run.filename}\""
      ),
      json: {
        status: :see_other,
        message: 'The run source file is located at the URL in the Location header. The link is valid for 15 minutes.',
      }
    )
  end

  def update
    presigned_request = $s3_bucket_external.presigned_post(
      key: "splits/#{@run.s3_filename}",
      content_length_range: 1..(25 * 1024 * 1024),
    )

    render status: :accepted, location: api_v4_run_url(@run), json: {
      status: :accepted,
      message: 'Run file ready to be replaced. Use the included presigned request to upload the file to S3, with an additional `file` field containing the run file.',
      id: @run.id36,
      uris: {
        api_uri: api_v4_run_url(@run),
        public_uri: run_url(@run),
      },
      presigned_request: {
        method: 'POST',
        uri: presigned_request.url,
        fields: presigned_request.fields,
      }
    }
  end

  private
  
  def source_file_params
    params.permit(:run)
  end
end
