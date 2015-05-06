module TimeSplitTracker
  def self.to_s
    "Time Split Tracker"
  end

  class Run < Run
    def self.sti_name
      :timesplittracker
    end
  end

  class Split < Split
  end

  class Parser < BabelBridge::Parser
    rule :timesplittracker_file, :first_line, :title_line, many?(:splits)

    rule :first_line,  :attempts, :tab, /([^\t\r\n]*)/, :tab, :newline
    rule :title_line,  :title, :tab, /([^\t\r\n]*)/, :newline
    rule :splits,      :title, :tab, :duration, :newline, :image_path, :tab, :newline

    rule :attempts,   /([^\t\r\n]*)/
    rule :title,      /([^\t]*)/
    rule :duration,   :time
    rule :image_path, /([^\t\r\n]*)/

    rule :time,       /(\d*\.\d*)/

    rule :newline,         :windows_newline
    rule :newline,         :unix_newline
    rule :tab,             "\t"
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
        parse_split(split, index == 0 ? 0 : splits.slice(0, index).map { |s| s.duration.to_s.to_f }.sum)
      end
    end

    def parse_split(segment, run_duration_so_far)
      Split.new.tap do |split|
        split.best = Split.new
        split.name = segment.title.to_s
        split.duration = segment.duration.to_s.to_f
        split.finish_time = run_duration_so_far + segment.duration.to_s.to_f
      end
    end
  end
end
