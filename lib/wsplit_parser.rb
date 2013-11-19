class WsplitParser < BabelBridge::Parser
  # Babel-Bridge's format is:
  #rule :rule_name, <list of tokens to match in order>
  # A token can be a string/regex (terminal), or another rule (nonterminal)
  # A question mark after a rule means "optional"
  rule :wsplit_file, :title_line, :attempts_line, :offset_line, :size_line, :splits_lines, :icons_line

  rule :title_line,    "Title=",     :title,    :newline
  rule :attempts_line, "Attempts=",  :attempts, :newline
  rule :offset_line,   "Offset=",    :offset,   :newline
  rule :size_line,     "Size=",      :size,     :newline
  rule :splits_lines,  many?([:splits_line,     :newline])
  rule :icons_line,    "Icons=",     /(.*)/,    :newline?

  rule :title,           /([^,\r\n]*)/
  rule :attempts,        /(\d+)/
  rule :offset,          /(\d+)/
  rule :size,            /([^\r\n]*)/
  rule :splits_line,     :split_title, ",", :zero, ",", :run_time, ",", :split_time

  rule :split_title,     /(([^,\r\n](?!Icons=))*)/
  rule :zero,            "0"
  rule :run_time,        /([\d.]+)/
  rule :split_time,      /([\d.]+)/

  rule :newline,         :windows_newline
  rule :newline,         :unix_newline
  rule :windows_newline, "\r\n"
  rule :unix_newline,    "\n"
end
