module Llanfair
  def self.to_s
    "Llanfair"
  end

  def self.to_sym
    :llanfair
  end

  class Parser < BabelBridge::Parser
    def parse(character_array)
      # Convert the array of character from string form to an actual array
      # Then pack the characters back to the original bytes
      file = RunFile.pack_binary(character_array)
      run = {}
      run[:time] = 0
      # A port of Nitrofski's import llanfair files function for wsplit
      file = StringIO.new(file)
      file.seek(197, 1)
      goal_len = file.read(2).unpack("n")[0]
      run[:goal] = file.read(goal_len)

      file.seek(1, 1)
      title_len = file.read(2).unpack("n")[0]
      run[:name] = file.read(title_len)

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
        segment_name = file.read(segment_name_len)

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
          name: segment_name.to_s,
          best: Split.new(duration: best_segment_time),
          duration: best_time,
          finish_time: run[:time] + best_time
        ).tap do |split|
          split.gold = split.duration > 0 && split.duration.round(5) == split.best.try(:round, 5)
          split.skipped = split.duration == 0.0
        end
        run[:time] += best_time

        file.seek(6, 1)

      end
      file.close
      run
    rescue
      nil
    end
  end
end
