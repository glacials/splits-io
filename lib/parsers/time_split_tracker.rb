module TimeSplitTracker
  class << self
    def shortname
      'timesplittracker'
    end

    def file_extension
      shortname
    end

    def read!(run_file)
      run = Parser.new.parse(run_file.file)

      ActiveRecord::Base.traction do
        if run[:segments].count > run_file.segments.count
          (run[:segments].count - run_file.segments.count).times { run_file.segments.new }
        elsif run[:segments].count < run_file.segments.count
          run_file.segments.limit(run_file.segments.count - run[:segments].count).destroy_all
        end

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
          program: :timesplittracker,
          time: run[:segments].sum { |s| s[:real_duration] },
          name: run[:name],
          category_id: nil
        )
      end
    end
  end

  private

  class Parser < BabelBridge::Parser
    rule :timesplittracker_file, :first_line, :title_line, many?(:splits)

    rule :first_line,  :attempts, :tab, /([^\t\r\n]*)/, :tab?, :newline
    rule :title_line,  :title, :tab, /([^\t\r\n]*)/, :newline
    rule :splits,      :title, :tab, :duration, :newline, :image_path, :tab, :newline

    rule :attempts,   /([^\t\r\n]*)/
    rule :title,      /([^\t]*)/
    rule :duration,   :time
    rule :image_path, /([^\t\r\n]*)/

    rule :time,       /(\d*:?\d*\.\d*)/

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
        segments: parse_splits(run.splits)
      }
    end

    private

    def parse_splits(splits)
      splits.map.with_index do |split, index|
        parse_split(split, index == 0 ? 0 : splits.slice(0, index).map { |s| s.duration.to_s.to_f }.sum)
      end
    end

    def parse_split(segment, run_duration_so_far)
      {
        name: segment.title.to_s,
        real_duration: segment.duration.to_s.to_f,
        best_real_duration: segment.duration.to_s.to_f,
        game_duration: nil,
        best_game_duration: nil
      }
    end
  end
end
