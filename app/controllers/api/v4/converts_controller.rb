class Api::V4::ConvertsController < Api::V4::ApplicationController

  before_action :check_parameters, only: [:create]

  def create
    run_file = RunFile.for_convert(params[:file])

    @run = Run.new(run_file: run_file, user: nil)
    unless @run.parses?(fast: params[:historic] != "1", convert: true)
      render status: 400, json: {
        status: 400,
        message: "Can't parse that file. We support #{Run.programs.to_sentence}."
      }
      return
    end

    program_extensions = {'livesplit' => '.lss', 'urn' => '.json'}
    file_name = "#{params[:file].original_filename.split(program_extensions[@run.program])[0]}"
    file_name << (program_extensions[params[:format]] || ".#{params[:format]}")

    if params[:format] == "json"
      new_file = render_to_string(json: @run, serializer: Api::V4::Convert::RunSerializer)
    else
      new_file = render_to_string("runs/#{params[:format]}", layout: false)
    end
    send_data(
      new_file,
      filename: file_name,
      layout: false
    )
  end

  private

  def check_parameters
    params.require(:file, :format)
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
    return
  end

end
