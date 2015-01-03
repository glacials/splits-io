class WSplitParser < BabelBridge::Parser
  rule :wsplit_file, :title_line, :attempts_line, :offset_line, :size_line, many?(:splits), :icons_line

  rule :title_line,    'Title=',     :title,    :newline
  rule :attempts_line, 'Attempts=',  :attempts, :newline
  rule :offset_line,   'Offset=',    :offset,   :newline
  rule :size_line,     'Size=',      :size,     :newline
  rule :splits,        :title,       ',',       :old_time, ',', :finish_time, ',', :best_time, :newline
  rule :icons_line,    'Icons=',     /(.*)/,    :newline?

  rule :title,    /([^,\r\n]*)/
  rule :attempts, /(\d+)/
  rule :offset,   /(\d*\.?\d*)/
  rule :size,     /([^\r\n]*)/

  rule :old_time,    :time
  rule :finish_time, :time
  rule :best_time,   :time

  rule :time,    /([\d\.]+)/

  rule :newline,         :windows_newline
  rule :newline,         :unix_newline
  rule :windows_newline, "\r\n"
  rule :unix_newline,    "\n"

  def parse(file)
    run = super(file)
    return nil if run.nil?
    {
      name: run.title.to_s,
      attempts: run.attempts.to_s.to_i,
      offset: run.offset.to_f,
      splits: parse_splits(run.splits)
    }
  end

  private

  def parse_splits(splits)
    splits.map.with_index do |split, index|
      parse_split(split, index == 0 ? 0 : splits[index - 1].finish_time.to_s.to_f)
    end
  end

  def parse_split(split, prev_split_finish_time)
    split = {
      best: {duration: split.best_time.to_s.to_f},
      name: split.title.to_s,
      duration: split.finish_time.to_s.to_f - prev_split_finish_time,
      finish_time: split.finish_time.to_s.to_f
    }
    split[:gold?] = split[:duration] > 0 && split[:duration].round(5) == split[:best][:duration].try(:round, 5)
    split[:skipped?] = split[:duration] == 0
    split
  end
end
