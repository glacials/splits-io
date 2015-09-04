module Urn
  def self.to_s
    "Urn"
  end

  def self.to_sym
    :urn
  end

  class Parser < BabelBridge::Parser
    def parse(json)
      json = JSON.parse(json)
      run = {}
      run[:name] = json["title"]
      run[:attempts] = json["attempt_count"].to_s
      run[:offset] = duration_in_seconds(json["start_delay"])
      run[:time] = duration_in_seconds(json["splits"].last["time"])
      run[:splits] = parse_splits(json["splits"])
      run
    rescue
      nil
    end

    private

    def parse_splits(splits)
      splits.map.with_index do |split, index|
        parse_split(split, index == 0 ? 0 : duration_in_seconds(splits[index-1]["time"]))
      end
    end

    def parse_split(segment, prev_split_finish_time)
      Split.new(
        best: Split.new(duration: duration_in_seconds(segment["best_segment"])),
        name: segment["title"].to_s,
        finish_time: duration_in_seconds(segment["time"])
      ).tap do |split|
        split.duration = [split.finish_time - prev_split_finish_time, 0].max
        split.gold = split.duration > 0 && split.duration.round(5) == split.best.try(:round, 5)
        split.skipped = split.duration == 0
      end
    end

    def duration_in_seconds(time)
      return 0 if time.blank?

      time.to_s.sub!('.', ':') if time.count('.') == 2
      ChronicDuration.parse(time, keep_zero: true)
    end
  end
end
