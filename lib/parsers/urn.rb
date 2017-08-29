module Urn
  def self.to_s
    "Urn"
  end

  def self.to_sym
    :urn
  end

  def self.file_extension
    'json'
  end

  def self.website
    'https://github.com/3snowp7im/urn'
  end

  def self.content_type
    'application/urn'
  end

  class Parser < BabelBridge::Parser
    def parse(json, options = {})
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
        name: segment["title"].to_s,
        realtime_best: duration_in_seconds(segment["best_segment"]),
        realtime_end: duration_in_seconds(segment["time"])
      ).tap do |split|
        split.realtime_duration = [split.realtime_end - prev_split_finish_time, 0].max
        split.realtime_skipped = split.realtime_duration == 0

        if split.realtime_duration > 0 && split.realtime_duration.round(5) == split.best.try(:round, 5)
          split.realtime_gold = true
        else
          split.realtime_gold = false
        end
      end
    end

    def duration_in_seconds(time)
      return 0 if time.blank?

      time.to_s.sub!('.', ':') if time.count('.') == 2
      ChronicDuration.parse(time, keep_zero: true)
    end
  end
end
