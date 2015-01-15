module Users::Pbs::Export::PanelsHelper
  def right_pad(string, to, with = ' ')
    string[0...to].ljust(to, with)
  end

  def left_pad(string, to, with = ' ')
    string[0...to].rjust(to, with)
  end

  def time(seconds)
    Time.at(seconds).utc.strftime("%k:%M:%S").gsub(' ', '')
  end

  def link(run)
    request.protocol + request.host_with_port + run.path
  end
end
