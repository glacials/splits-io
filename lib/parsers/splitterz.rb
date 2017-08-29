module SplitterZ
  def self.to_s
    "SplitterZ"
  end

  def self.to_sym
    :splitterz
  end

  def self.file_extension
    'splitterz'
  end

  def self.website
    'http://splitterz420.blogspot.com/'
  end

  def self.content_type
    'application/splitterz'
  end

  class Parser < BabelBridge::Parser
    rule :splitterz_file, :title_line, many?(:splits), :newline?

    rule :title_line, :title, ',', :attempts, :newline
    rule :splits,     :title, ',', :run_time, ',', :best_time, :local_img_path?, :newline

    rule :title,     /([^,\r\n]*)/
    rule :attempts,  /(\d*)/
    rule :run_time,  :time
    rule :best_time, :time
    rule :local_img_path, /^.*$/

    rule :time, :hours, ':', :minutes, ':', :seconds
    rule :time, :minutes, ':', :seconds

    rule :hours,   /\d+/
    rule :minutes, /\d+/
    rule :seconds, /\d+\.\d+/

    rule :newline,         :windows_newline
    rule :newline,         :unix_newline
    rule :windows_newline, "\r\n"
    rule :unix_newline,    "\n"

    def parse(file, options = {})
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
        split.name = segment.title.to_s
        split.realtime_duration = duration_in_seconds(segment.run_time.time) - run[:time]
        split.realtime_end = duration_in_seconds(segment.run_time.time)
        split.realtime_best = duration_in_seconds(segment.best_time.time)
        run[:time] += split.realtime_duration
        run[:splits] << split
      end
      run
    end

    def duration_in_milliseconds(time)
      hours = 0
      if time.respond_to?(:hours)
        hours = time.hours.to_s.to_i
      end

      minutes = time.minutes.to_s.to_i
      seconds = time.seconds.to_s.to_f

      (hours * 60 * 60 * 1000) + (minutes * 60 * 1000) + (seconds * 1000)
    end

    def duration_in_seconds(time)
      duration_in_milliseconds(time).to_f / 1000
    end
  end
end
