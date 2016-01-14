class ConvertsController < ApplicationController

  def new
  end

  def create
    params.require(:file)
    params.require(:format)
    run_file = RunFile.for_convert(params[:file])
    @run = Run.new(run_file: run_file, user: nil)
    @run.parse(fast: ["on", "1"].include?(params[:historic]) ? false : true, convert: true)
    unless @run.splits
      redirect_to cant_parse and return
    end
    extension = {'livesplit' => 'lss',
      'urn' => 'json'
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

end
