module SplitterZ
  class Run < Run
    def self.sti_name
      :splitterz
    end
  end

  class Split < Split
  end

  class Parser < BabelBridge::Parser
    rule :splitterz_file, :title_line, many?(:splits)

    rule :title_line, :title, ',', :attempts, :newline
    rule :splits,     :title, ',', :run_time, ',', :best_time, :newline

    rule :title,     /([^,\r\n]*)/
    rule :attempts,  /(\d*)/
    rule :run_time,  :time
    rule :best_time, :time

    rule :time, /(\d*:?\d*:?\d*.\d*)/

    rule :newline,         :windows_newline
    rule :newline,         :unix_newline
    rule :windows_newline, "\r\n"
    rule :unix_newline,    "\n"

    def parse(file)
      splits = super(file)
      return nil unless splits
      run = {}
      run[:game] = nil
      run[:name] = splits.title.to_s
      run[:attempts] = splits.attempts.to_s.to_i
      run[:splits] = []
      run[:time] = 0
      splits.splits.each do |segment|
        split = Split.new
        split.best = {}
        split.name = segment.title
        split.duration = duration_in_seconds_of(segment.run_time.to_s) - run[:time]
        split.finish_time = duration_in_seconds_of(segment.run_time.to_s)
        split.best.duration = duration_in_seconds_of(segment.best_time.to_s)
        run[:time] += split.duration
        run[:splits] << split
      end
      run
    rescue
      nil
    end

    def duration_in_seconds_of(time)
      Time.parse(time).seconds_since_midnight
    end
  end
end
