class Api::V4::ConvertsController < Api::V4::ApplicationController

  before_action :check_parameters, only: [:create]

  def create
    if params[:file].respond_to?(:read)
      file_text = params[:file].read
      if file_text[8..29] == "org.fenix.llanfair.Run"
        run_file = RunFile.new(file: RunFile.unpack_binary(file_text))
      else
        run_file = RunFile.new(file: file_text)
      end
    end

    @run = Run.new(run_file: run_file, user: nil)
    @run.parse(fast: ["on", "1"].include?(params[:historic]) ? true : false, convert: true)

    extension = {'livesplit' => 'lss',
      'urn' => 'json',
    }[params[:format]] || params[:format]

    if params[:format] == "json"
      new_file = render_to_string(json: @run, serializer: Api::V4::Convert::RunSerializer)
    else
      new_file = render_to_string("runs/#{params[:format]}", layout: false)
    end
    send_data(
      new_file,
      filename: "#{params[:file].original_filename.split(".")[0..-1].join}.#{extension}",
      layout: false
    )
  end

  private

  def check_parameters
    params.require(:file)
    params.require(:format)
    supported = (Run.programs - [Llanfair]) + ["json"]
    unless supported.include?(params[:format])
      render status: 400, json: {
        status: 400,
        message: "Convert supports the following formats: #{supported}"
      }
    end
  end

end
