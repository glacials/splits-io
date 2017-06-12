class ConvertsController < ApplicationController
  def new
  end

  def create
    params.require(:file)
    params.require(:format)

    filename = SecureRandom.uuid

    @run = Run.create(
      user: nil,
      s3_filename: filename
    )

    $s3_bucket.put_object(
      key: "splits/#{filename}",
      body: params.require(:file)
    )

    @run.parse_into_activerecord

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
  rescue ActionController::ParameterMissing
    flash.now[:alert] = "You forgot to select a file."
    render :new
  end
end
