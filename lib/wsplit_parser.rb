class WsplitParser < BabelBridge::Parser
  # Babel-Bridge's format is:
  #rule :rule_name, <list of tokens to match in order>
  # A token can be a string/regex (terminal), or another rule (nonterminal)
  # A question mark after a rule means "optional"
  rule :wsplit_file, :title_line, :attempts_line, :offset_line, :size_line, many?(:splits), :icons_line

  rule :title_line,    "Title=",     :title,    :newline
  rule :attempts_line, "Attempts=",  :attempts, :newline
  rule :offset_line,   "Offset=",    :offset,   :newline
  rule :size_line,     "Size=",      :size,     :newline
  rule :splits,        :title, ",", :zero, ",", :runtime, ",", :time, :newline
  rule :icons_line,    "Icons=",     /(.*)/,    :newline?

  rule :title,    /([^,\r\n]*)/
  rule :attempts, /(\d+)/
  rule :offset,   /(\d+)/
  rule :size,     /([^\r\n]*)/

  rule :title,   /([^,\r\n]*)/
  rule :zero,    "0"
  rule :runtime, /([\d.]+)/
  rule :time,    /([\d.]+)/

  rule :newline,         :windows_newline
  rule :newline,         :unix_newline
  rule :windows_newline, "\r\n"
  rule :unix_newline,    "\n"
end
