module Urn
  class << self
    def shortname
      'urn'
    end

    def file_extension
      'json'
    end

    def read!(run_file)
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
        program: :timesplittracker,
        time: run[:segments].sum { |s| s[:real_duration] },
        name: run[:name],
        category_id: nil
      )
    end
  end

  private

  class Parser < BabelBridge::Parser
    def parse(json)
      json = JSON.parse(json)
      run = {}
      run[:name] = json['title']
      run[:attempts] = json['attempt_count'].to_s
      run[:offset] = duration_in_seconds_of(json['start_delay'])
      run[:segments] = parse_splits(json['splits'])
      run
    end

    private

    def parse_splits(splits)
      splits.map.with_index do |split, index|
        parse_split(split, index == 0 ? 0 : duration_in_seconds_of(splits[index-1]['time']))
      end
    end

    def parse_split(segment, prev_split_finish_time)
      {
        name: segment['title'].to_s,
        real_duration: [duration_in_seconds_of(segment['time']) - prev_split_finish_time, 0].max,
        best_real_duration: duration_in_seconds_of(segment['best_segment'])
      }
    end

    def duration_in_seconds_of(time)
      return 0 if time.blank?

      time.to_s.sub!('.', ':') if time.count('.') == 2
      ChronicDuration.parse(time, keep_zero: true)
    end
  end
end
