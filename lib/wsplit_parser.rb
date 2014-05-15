class WSplitParser < BabelBridge::Parser
  rule :wsplit_file, :title_line, :attempts_line, :offset_line, :size_line, many?(:splits), :icons_line

  rule :title_line,    'Title=',     :title,    :newline
  rule :attempts_line, 'Attempts=',  :attempts, :newline
  rule :offset_line,   'Offset=',    :offset,   :newline
  rule :size_line,     'Size=',      :size,     :newline
  rule :splits,        :title,       ',',       :old_time, ',', :run_time, ',', :best_time, :newline
  rule :icons_line,    'Icons=',     /(.*)/,    :newline?

  rule :title,    /([^,\r\n]*)/
  rule :attempts, /(\d+)/
  rule :offset,   /(\d*\.?\d*)/
  rule :size,     /([^\r\n]*)/

  rule :old_time,  :time
  rule :run_time,  :time
  rule :best_time, :time

  rule :time,    /([\d\.]+)/

  rule :newline,         :windows_newline
  rule :newline,         :unix_newline
  rule :windows_newline, "\r\n"
  rule :unix_newline,    "\n"

  def parse(file)
    splits = super(file) or return nil
    run = OpenStruct.new
    run.game = nil
    run.name = splits.title.to_s
    run.attempts = splits.attempts.to_s.to_i
    run.offset = splits.offset.to_f
    run.splits = []
    run.time = 0
    splits.splits.each do |segment|
      split = OpenStruct.new
      split.old = OpenStruct.new
      split.best = OpenStruct.new
      split.name = segment.title
      split.duration = segment.run_time.to_s.to_f - run.time
      split.finish_time = segment.run_time.to_s.to_f
      split.best.duration = segment.best_time.to_s.to_f
      split.parent = run
      run.time += split.duration
      run.splits << split
    end
    run
  rescue
    nil
  end
end
