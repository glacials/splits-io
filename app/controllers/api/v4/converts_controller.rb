class Api::V4::ConvertsController < Api::V4::ApplicationController
  before_action :check_parameters, only: [:create]

  def create
    params.require(:file)
    params.require(:format)

    filename = SecureRandom.uuid

    @run = Run.create(
      user:        nil,
      s3_filename: filename
    )

    $s3_bucket_internal.put_object(
      key:  "splits/#{filename}",
      body: params.require(:file)
    )

    @run.parse_into_db
    if @run.program.nil?
      render status: :bad_request, json: {
        status:  400,
        message: 'Unable to parse that run.'
      }
      return
    end

    $s3_shutdown_prep_bucket.put_object(
      key: "extensions/#{@run.id}",
      body: Run.program(@run.program).file_extension,
    )
    $s3_shutdown_prep_bucket.put_object(
      key: "#{@run.id}",
      body: filename,
    )

    # Use a new find by to eager load the segment histories to prevent n+1 queries
    @run = Run.includes(segments: [:histories]).find(@run.id)

    old_extension = Run.program(@run.program).file_extension

    new_extension = if Run.program(params[:format])
                      Run.program(params[:format]).file_extension
                    else
                      params[:format]
                    end
    filename_without_extension = params[:file].original_filename.split(".#{old_extension}")[0]

    filename = "#{filename_without_extension}.#{new_extension}"
    response.set_header('X-Filename', filename)

    new_file = if params[:format] == 'json'
                 render_to_string(json: Api::V4::RunBlueprint.render_as_hash(@run, view: :convert, root: :run, toplevel: :run, historic: true))
               else
                 render_to_string("runs/exports/#{params[:format]}", layout: false)
               end
    send_data(
      new_file,
      filename: filename,
      layout:   false
    )
  end

  private

  def check_parameters
    params.require(:file)
    params.require(:format)
    supported = Run.exportable_programs.map(&:to_sym).map(&:to_s) + ['json']
    unless supported.map(&:to_s).include?(params[:format])
      render status: :bad_request, json: {
        status:  400,
        message: "Convert supports the following output formats: #{supported.to_sentence}."
      }
    end
  rescue ActionController::ParameterMissing
    render status: :bad_request, json: {
      status:  400,
      message: "Missing 'file' or 'format' parameter. Make sure to include both in your request."
    }
  end
end
