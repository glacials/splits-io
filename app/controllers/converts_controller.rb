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
      redirect_to cant_parse && return
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

end
