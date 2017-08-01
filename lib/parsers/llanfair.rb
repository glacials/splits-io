module Llanfair
  def self.to_s
    "Llanfair"
  end

  def self.to_sym
    :llanfair
  end

  def self.file_extension
    'llanfair'
  end

  def self.website
    'http://jenmaarai.com/llanfair/en/'
  end

  class Parser
    def parse(file, options = {})
      run = {
        realtime_history: [],
        indexed_history: {}
      }
      run[:realtime_time] = 0
      # A port of Nitrofski's import llanfair files function for wsplit
      file = StringIO.new(file)
      file.seek(197, 1)
      goal_len = file.read(2).unpack("n")[0]
      run[:goal] = file.read(goal_len)

      file.seek(1, 1)
      title_len = file.read(2).unpack("n")[0]
      run[:name] = file.read(title_len).force_encoding("UTF-8")

      file.seek(6, 1)
      segment_count = file.read(4).unpack("N")[0]

      time_object_found = false
      icon_object_found = false
      run[:splits] = []

      file.seek(143, 1)

      (0...segment_count).each do |seg|
        best_segment_millis = 0

        buffer = file.read(1).ord
        unless buffer == 112

          if !time_object_found
            time_object_found = true
            file.seek(54, 1)
          else
            file.seek(5, 1)
          end

          best_segment_millis = file.read(8).reverse!.unpack("Q")[0]

        end

        buffer = file.read(1).ord
        unless buffer == 112
          seek_offset_base = 0

          if !icon_object_found
            icon_object_found = true
            file.seek(188, 1)
            seek_offset_base = 37
          else
            file.seek(5, 1)
            seek_offset_base = 24
          end

          icon_height = file.read(4).unpack("N")[0]
          icon_width = file.read(4).unpack("N")[0]

          file.seek(seek_offset_base + (icon_width * icon_height * 4), 1)

        end

        file.seek(1, 1)
        segment_name_len = file.read(2).unpack("n")[0]
        segment_name = file.read(segment_name_len).force_encoding("UTF-8")

        best_time_millis = 0
        buffer = file.read(1).ord
        if buffer == 113
          file.seek(4, 1)
          best_time_millis = best_segment_millis
        elsif buffer != 112
          file.seek(5, 1)
          best_time_millis = file.read(8).reverse!.unpack("Q")[0]
        end

        best_time = best_time_millis / 1000.0
        best_segment_time = best_segment_millis / 1000.0

        run[:splits] << Split.new(
          name: segment_name.to_s.force_encoding("UTF-8"),
          realtime_best: best_segment_time,
          realtime_duration: best_time,
          realtime_end: run[:realtime_time] + best_time
        ).tap do |split|
          if split.realtime_duration > 0 && split.realtime_duration.round(5) == split.realtime_best.round(5)
            split.realtime_gold = true
          else
            split.realtime_gold = false
          end
          split.realtime_skipped = split.realtime_duration == 0.0
          split.realtime_start = split.realtime_end - split.realtime_duration
        end
        run[:realtime_time] += best_time

        file.seek(6, 1)

      end
      file.close
      run
    rescue
      nil
    end
  end
end
