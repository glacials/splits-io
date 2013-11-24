class TimesplittrackerParser < BabelBridge::Parser
  # Babel-Bridge's format is:
  #rule :rule_name, <list of tokens to match in order>
  # A token can be a string/regex (terminal), or another rule (nonterminal)
  # A question mark after a rule means "optional"
  rule :timesplittracker_file, :first_line, :title_line, many?(:splits)

  rule :first_line, /([^\t\r\n]*)/, :tab, /([^\t\r\n]*)/, :tab, :newline
  rule :title_line, /([^\t\r\n]*)/, :tab, /([^\t\r\n]*)/, :newline
  rule :splits,      :title, :tab, :best_time, :newline, :image_path, :tab, :newline

  rule :title,      /([^\t]*)/
  rule :best_time,  :time
  rule :image_path, /([^\t\r\n]*)/

  rule :time,       /(\d*\.\d*)/

  rule :newline,         :windows_newline
  rule :newline,         :unix_newline
  rule :tab,             "\t"
  rule :windows_newline, "\r\n"
  rule :unix_newline,    "\n"
end
