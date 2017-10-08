class Api::V4::ConvertsController < Api::V4::ApplicationController
  before_action :check_parameters, only: [:create]

  def create
    params.require(:file)
    params.require(:format)

    filename = SecureRandom.uuid

    @run = Run.create(
      user: nil,
      s3_filename: filename
    )

    $s3_bucket_internal.put_object(
      key: "splits/#{filename}",
      body: params.require(:file)
    )

    @run.parse_into_db
    if @run.program == nil
      render status: 400, json: {
        status: 400,
        message: "Unable to parse that run."
      }
      return
    end

    @run.reload

    old_extension = Run.program(@run.program).file_extension

    if Run.program(params[:format])
      new_extension = Run.program(params[:format]).file_extension
    else
      new_extension = params[:format]
    end
    filename_without_extension = params[:file].original_filename.split(old_extension)[0]

    filename = "#{filename_without_extension}.#{new_extension}"

    if params[:format] == "json"
      new_file = render_to_string(json: @run, serializer: Api::V4::Convert::RunSerializer)
    else
      new_file = render_to_string("runs/#{params[:format]}", layout: false)
    end
    send_data(
      new_file,
      filename: filename,
      layout: false
    )
  end

  private

  def check_parameters
    params.require(:file)
    params.require(:format)
    supported = (Run.exportable_programs.map(&:to_sym).map(&:to_s)) + ["json"]
    unless supported.map(&:to_s).include?(params[:format])
      render status: 400, json: {
        status: 400,
        message: "Convert supports the following output formats: #{supported.to_sentence}."
      }
    end
  rescue ActionController::ParameterMissing
    render status: 400, json: {
      status: 400,
      message: "Missing 'file' or 'format' parameter. Make sure to include both in your request."
    }
  end
end
