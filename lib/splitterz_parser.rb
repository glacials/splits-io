class SplitterzParser < BabelBridge::Parser
  # Babel-Bridge's format is:
  #rule :rule_name, <list of tokens to match in order>
  # A token can be a string/regex (terminal), or another rule (nonterminal)
  # A question mark after a rule means "optional"
  rule :splitterz_file, :title_line, many?(:splits)

  rule :title_line, :title, ",", :attempts
  rule :splits,     :title, ",", :run_time, ",", :best_time, :newline

  rule :title,     /([^,]*)/
  rule :attempts,  /(\d*)/
  rule :run_time,  :time
  rule :best_time, :time

  rule :time, /(\d*:?\d*:?\d*.\d*)/

  rule :newline,         :windows_newline
  rule :newline,         :unix_newline
  rule :windows_newline, "\r\n"
  rule :unix_newline,    "\n"
end
