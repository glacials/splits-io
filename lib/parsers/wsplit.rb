module WSplit
  def self.to_s
    "WSplit"
  end

  def self.to_sym
    :wsplit
  end

  def self.file_extension
    'wsplit'
  end

  def self.website
    'https://github.com/Nitrofski/WSplit'
  end

  class Parser < BabelBridge::Parser
    rule :wsplit_file, :title_line, :optional_goal_line, :attempts_line, :offset_line, :size_line, many?(:splits), :icons_line

    rule :title_line,         'Title=',     :run_title, :newline
    rule :optional_goal_line, 'Goal=',      :goal,      :newline
    rule :optional_goal_line, ''
    rule :attempts_line,      'Attempts=',    :attempts, :newline
    rule :offset_line,        'Offset=',      :offset,   :newline
    rule :size_line,          'Size=',        :size,     :newline
    rule :splits,             :segment_title, ',',       :old_time, ',', :finish_time, ',', :best_time, :newline
    rule :icons_line,         'Icons=',       /(.*)/,    :newline?

    rule :run_title,     /([^\r\n]*)/
    rule :segment_title, /([^,\r\n]*)/
    rule :goal,          /([^\r\n]*)/
    rule :attempts,      /(\d+)/
    rule :offset,        /(\d*\.?\d*)/
    rule :size,          /([^\r\n]*)/

    rule :old_time,    :time
    rule :finish_time, :time
    rule :best_time,   :time

    rule :time,    /([\d\.]+)/

    rule :newline,         :windows_newline
    rule :newline,         :unix_newline
    rule :windows_newline, "\r\n"
    rule :unix_newline,    "\n"

    def parse(file, options = {})
      return unless file.ascii_only?

      (run = super(file)) && {
        name: run.run_title.to_s,
        attempts: run.attempts.to_s.to_i,
        offset: run.offset.to_f,
        splits: parse_splits(run.splits),
        realtime_history: [],
        indexed_history: {}
      }
    end

    private

    def parse_splits(splits)
      splits.map.with_index do |split, index|
        parse_split(
          split,
          index == 0 ? 0 : preceding_unskipped_split(splits, index).try(:finish_time).to_s.to_f
        )
      end
    end

    def parse_split(segment, prev_segment_finish_time)
      segment = Split.new(
        name: segment.segment_title.to_s,
        realtime_duration: [trunc(segment.finish_time.to_s) - trunc(prev_segment_finish_time), 0].max,
        realtime_end: trunc(segment.finish_time.to_s),
        realtime_best: trunc(segment.best_time.to_s)
      )

      segment.realtime_gold = segment.realtime_duration > 0 && segment.realtime_duration == segment.realtime_best
      segment.realtime_skipped = segment.realtime_duration == 0
      segment.realtime_start = segment.realtime_end - segment.realtime_duration

      return segment
    end

    def preceding_unskipped_split(splits, i)
      splits[0...i].reverse.map do |split, j|
        return split if trunc(split.finish_time.to_s) != 0
      end.last
    end

    def trunc(n)
      if n.nil?
        return nil
      end

      return n.to_f.to_d.truncate(2)
    end
  end
end
