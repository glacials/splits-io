module TimeSplitTracker
  def self.to_s
    "Time Split Tracker"
  end

  def self.to_sym
    :timesplittracker
  end

  def self.file_extension
    'timesplittracker'
  end

  def self.website
    'https://dunnius.itch.io/time-split-tracker-windows'
  end

  class Parser < BabelBridge::Parser
    rule :timesplittracker_file, :first_line, :title_line, many?(:splits)

    rule :first_line,  :attempts, :tab, /([^\t\r\n]*)/, :optional_tab, :game_name, :newline
    rule :title_line,  :title, :tab, :best_splits_title?, :tab?, :time_title?, :newline
    rule :splits,      :title, :tab, :best_duration, :tab, :finish_time?, :newline, :image_path, many?(:tab), :newline

    rule :best_splits_title, 'Best Splits'
    rule :time_title,        'Time'

    rule :attempts,      /([^\t\r\n]*)/
    rule :title,         /([^\t]*)/
    rule :game_name,     /([^\r\n]*)/
    rule :best_duration, :time
    rule :finish_time,   :time
    rule :image_path,    /([^\t\r\n]*)/

    rule :time, /(((\d+:)?\d+:)?\d*\.\d*)/

    rule :newline,         :windows_newline
    rule :newline,         :unix_newline
    rule :tab,             "\t"
    rule :optional_tab,    /\t?/
    rule :windows_newline, "\r\n"
    rule :unix_newline,    "\n"

    def parse(file, options = {})
      if file.nil? || file.ascii_only?
        return nil
      end

      run = super(file)
      return nil if run.nil?
      {
        name: run.title.to_s,
        attempts: run.attempts.to_s.to_i,
        offset: run.offset.to_f,
        splits: parse_splits(run.splits),
        history: [],
        indexed_history: {}
      }
    end

    private

    def parse_splits(splits)
      splits.map.with_index do |segment, index|
        prev_split_finish_time = 0
        if index > 0
          prev_split_finish_time = splits[index - 1].finish_time
        end

        parse_split(segment, prev_split_finish_time)
      end
    end

    def parse_split(segment, prev_segment_finish_time)
      Split.new.tap do |split|
        split.name = segment.title.to_s
        split.realtime_duration = duration_in_seconds(segment.finish_time.to_s) - duration_in_seconds(prev_segment_finish_time.to_s)
        split.realtime_best = duration_in_seconds(segment.best_duration.to_s)
        split.realtime_end = duration_in_seconds(segment.finish_time.to_s)
      end
    end

    def duration_in_seconds(time)
      return 0 if time.blank?

      time.sub!('.', ':') if time.count('.') == 2
      ChronicDuration.parse(time, keep_zero: true)
    end
  end
end
