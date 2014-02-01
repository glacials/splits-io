class TimesplittrackerParser < BabelBridge::Parser
  # Babel-Bridge's format is:
  #rule :rule_name, <list of tokens to match in order>
  # A token can be a string/regex (terminal), or another rule (nonterminal)
  # A question mark after a rule means "optional"
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
    splits = super(file) or return nil
    run = OpenStruct.new
    run.game = nil
    run.name = splits.title.to_s
    run.attempts = splits.attempts.to_s.to_i
    run.offset = splits.offset.to_f
    run.splits = Array.new
    run.time = 0
    splits.splits.each do |segment|
      split = OpenStruct.new
      split.old = OpenStruct.new
      split.best = OpenStruct.new
      split.name = segment.title
      split.duration = segment.best_time.to_s.to_f
      split.finish_time = run.time + segment.best_time.to_s.to_f
      split.parent = run
      run.time += split.duration
      run.splits << split
    end
    run
  end
end
