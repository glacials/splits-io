class Api::V4::ConvertsController < Api::V4::ApplicationController

  def create
    params.require(:file)
    if params[:file].respond_to?(:read)
      file_text = params[:file].read
      if file_text[8..29] == "org.fenix.llanfair.Run"
        run_file = RunFile.new(file: RunFile.unpack_binary(file_text))
      else
        run_file = RunFile.new(file: file_text)
      end
    end
    # Not threadsafe if moving away from unicorn
    Run.skip_callback(:create, :after, :refresh_game)
    Run.skip_callback(:create, :after, :discover_runner)
    Run.skip_callback(:update, :after, :discover_runner)
    Category.skip_callback(:create, :before, :autodetect_shortname)
    Category.skip_callback(:touch, :after, :destroy)
    Game.skip_callback(:touch, :after, :destroy)
    @run = Run.new(run_file: run_file)
    puts @run.inspect

    @run.convert(fast: params[:include_history] == "on" ? true : false)
    puts @run.inspect
    extension = {'livesplit' => 'lss',
      'urn' => 'json',
      'splits_io' => 'json'
    }[params[:program]] || params[:program]
    if params[:program] == "splits_io"
      new_file = render_to_string(json: @run, serializer: Api::V4::Convert::RunSerializer)
    else
      new_file = render_to_string("runs/#{params[:program]}", layout: false)
    end
    send_data(
      new_file,
      filename: "#{params[:file].original_filename}.#{extension}",
      layout: false
    )
  end

end
