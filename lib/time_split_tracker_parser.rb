class TimeSplitTrackerParser < BabelBridge::Parser
  rule :timesplittracker_file, :first_line, :title_line, many?(:splits)

  rule :first_line,  :attempts, :tab, /([^\t\r\n]*)/, :tab, :newline
  rule :title_line,  :title, :tab, /([^\t\r\n]*)/, :newline
  rule :splits,      :title, :tab, :best_time, :newline, :image_path, :tab, :newline

  rule :attempts,   /([^\t\r\n]*)/
  rule :title,      /([^\t]*)/
  rule :best_time,  :time
  rule :image_path, /([^\t\r\n]*)/

  rule :time,       /(\d*\.\d*)/

  rule :newline,         :windows_newline
  rule :newline,         :unix_newline
  rule :tab,             "\t"
  rule :windows_newline, "\r\n"
  rule :unix_newline,    "\n"

  def parse(file)
    splits = super(file)
    return nil unless splits
    run = {}
    run[:game] = nil
    run[:name] = splits.title.to_s
    run[:attempts] = splits.attempts.to_s.to_i
    run[:offset] = splits.offset.to_f
    run[:splits] = []
    run[:time] = 0
    splits.splits.each do |segment|
      split = {}
      split[:best] = {}
      split[:name] = segment.title
      split[:duration] = segment.best_time.to_s.to_f
      split[:finish_time] = run[:time] + segment.best_time.to_s.to_f
      run[:time] += split[:duration]
      run[:splits] << split
    end
    run
  rescue
    nil
  end
end
