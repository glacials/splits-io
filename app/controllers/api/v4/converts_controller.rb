class Api::V4::ConvertsController < Api::V4::ApplicationController
  before_action :check_parameters, only: [:create]

  def create
    run_file = RunFile.for_convert(params[:file])

    @run = Run.new(run_file: run_file)
    unless @run.parses?(fast: params[:historic] != "1", convert: true)
      render status: 400, json: {
        status: 400,
        message: "Can't parse that file. We support #{Run.programs.to_sentence}."
      }
      return
    end

    old_extension = Run.program(@run.program).file_extension
    new_extension = Run.program(params[:format]).file_extension

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
    supported = (Run.programs - [Llanfair]) + ["json"]
    unless supported.map(&:to_s).include?(params[:format])
      render status: 400, json: {
        status: 400,
        message: "Convert supports the following formats: #{supported.to_sentence}"
      }
    end
  rescue ActionController::ParameterMissing
    render status: 400, json: {
      status: 400,
      message: "Missing 'file' or 'format' parameter. Make sure to include both in your request."
    }
  end
end
