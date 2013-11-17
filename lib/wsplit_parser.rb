class WsplitParser < BabelBridge::Parser
  rule :wsplit_file, :title_line, :attempts_line, :offset_line, :size_line, :splits_lines, :icons_line
  rule :title_line,    "Title=",    :title,    :newline
  rule :attempts_line, "Attempts=", :attempts, :newline
  rule :offset_line,   "Offset=",   :offset,   :newline
  rule :size_line,     "Size=",     :size,     :newline
  rule :splits_lines, :splits_line, :splits_lines?
  rule :icons_line,    "Icons=",    /(.*)/,    :newline?
  rule :title,    /([^,\r\n]*)/
  rule :attempts, /(\d+)/
  rule :offset,   /(\d+)/
  rule :size,     /([^\r\n]*)/
  rule :splits_line, :split_title, ",", :zero, ",", :bestrun_time, ",", :bestsplit_time, :newline
  rule :split_title, /(([^,\r\n](?!Icons=))*)/
  rule :zero, "0"
  rule :bestrun_time, /(\d+)/
  rule :bestsplit_time, /(\d+)/
  rule :newline, :windows_newline
  rule :newline, :unix_newline
  rule :windows_newline, "\r\n"
  rule :unix_newline, "\n"
end
