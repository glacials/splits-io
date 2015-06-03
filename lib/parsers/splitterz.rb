module SplitterZ
  def self.read!(run_file)
    run = Parser.new.parse(run_file.file)

    (run[:segments].count - run_file.segments.count).times { run_file.segments << run_file.segments.new }

    run[:segments].map.with_index do |segment, index|
      run_file.segments[index].update(
        order: index,
        name: segment[:name],
        real_duration: segment[:real_duration],
        best_real_duration: segment[:best_real_duration],
        game_duration: nil,
        best_game_duration: nil
      )
    end.all? && run_file.runs.update_all(
      program: :splitterz,
      time: run[:segments].sum { |s| s[:real_duration] },
      name: run[:name],
      category_id: nil
    )
  end

  private

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
      parsed_file = super(file)
      return nil unless parsed_file
      run = {}
      run[:game] = nil
      run[:name] = parsed_file.title.to_s
      run[:attempts] = parsed_file.attempts.to_s.to_i
      run[:segments] = []
      run[:time] = 0
      parsed_file.splits.each do |segment|
        run[:segments] << {
          name: segment.title,
          real_duration: duration_in_seconds_of(segment.run_time.to_s) - run[:time],
          best_real_duration: duration_in_seconds_of(segment.best_time.to_s)
        }
        run[:time] += (duration_in_seconds_of(segment.run_time.to_s) - run[:time])
      end
      run
    end

    def duration_in_seconds_of(time)
      Time.parse(time).seconds_since_midnight
    end
  end
end
