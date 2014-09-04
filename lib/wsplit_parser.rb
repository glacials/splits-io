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
    run = super(file) && {
      game: nil,
      name: run.title.to_s,
      attempts: run.attempts.to_s.to_i,
      offset: run.offset.to_f,
      splits: run.splits.map.with_index do |segment, index|
        parse_one_split(segment, index == 0 ? 0 : run.splits[index - 1].run_time.to_s.to_f)
      end
    }
  rescue
    nil
  end

  private

  def parse_one_split(segment, last_segment_time)
    {
      best: { duration: segment.best_time.to_s.to_f },
      name: segment.title.to_s,
      duration: segment.run_time.to_s.to_f - last_segment_time,
      finish_time: segment.run_time.to_s.to_f
    }
  end
end
