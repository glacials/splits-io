class SegmentGroup
  attr_accessor :segments

  def initialize(segments)
    self.segments = segments
  end

  def id
    "#{segments.first.id}-subsplit"
  end

  def display_name
    match = /\{(.+?)}/.match(segments.last.name)
    match[1] if match
  end

  def duration(timing)
    segments.map do |segment|
      segment.duration(timing)
    end.sum
  end

  def end(timing)
    segments.last.end(timing)
  end

  def gold?(timing)
    false
  end

  def reduced?(timing)
    false
  end

  def segment_group_parent?
    true
  end

  def segment_number
    segments.first.segment_number
  end

  def skipped?(timing)
    false
  end

  def shortest_duration(timing)
    Duration.new(subsplit_durations_by_attempt[timing].values.min)
  end

  def history_stats(timing)
    values = subsplit_durations_by_attempt[timing].values.sort
    mean = values.sum / subsplit_durations_by_attempt[timing].keys.length.to_f
    variance_sum = values.inject(0) { |accum, i| accum + (i-mean)**2 }
    sample_variance = values.length == 1 ? 0 : variance_sum / (subsplit_durations_by_attempt[timing].keys.length - 1).to_f
    {
      standard_deviation: Math.sqrt(sample_variance),
      mean: mean,
      median: values.length == 1 ? values[0] : values[values.length / 2 + 1], # Not actual median, but matches the DB query
      percentiles: {
        10 => percentile(values, 0.1),
        90 => percentile(values, 0.9),
        99 => percentile(values, 0.99)
      }
    }
  end

  def subsplit_durations
    durations = {}
    subsplit_durations_by_attempt.keys.each do |timing|
      subsplit_durations_by_attempt[timing].keys.each do |attempt_number|
        durations[attempt_number] = {
          attempt_number: attempt_number,
          'realtime_duration_ms' => 0,
          'gametime_duration_ms' => 0
        } unless durations[attempt_number]
        durations[attempt_number]["#{timing}time_duration_ms"] = subsplit_durations_by_attempt[timing][attempt_number]
      end
    end
    durations.values.to_a
  end

  private

  def subsplit_durations_by_attempt
    return @subsplit_durations_by_attempt if @subsplit_durations_by_attempt
    @subsplit_durations_by_attempt = {
      Run::REAL => Hash.new { |h, k| h[k] = [] },
      Run::GAME => Hash.new { |h, k| h[k] = [] }
    }

    segments.each do |segment|
      segment.histories.each do |history|
        previous_attempt = segments[segment.segment_number - 1]&.histories&.find { |attempt| attempt.attempt_number == history.attempt_number }
        @subsplit_durations_by_attempt[Run::REAL][history.attempt_number] << history.realtime_duration_ms unless history.realtime_duration_ms == 0 || previous_attempt&.realtime_duration_ms == 0
        @subsplit_durations_by_attempt[Run::GAME][history.attempt_number] << history.gametime_duration_ms unless history.gametime_duration_ms == 0 || previous_attempt&.gametime_duration_ms == 0
      end
    end
    @subsplit_durations_by_attempt.keys.each do |timing|
      max_length = @subsplit_durations_by_attempt[timing].values.map(&:length).max
      @subsplit_durations_by_attempt[timing].delete_if { |key, value| value.length < max_length}
    end

    @subsplit_durations_by_attempt.keys.each do |timing|
      @subsplit_durations_by_attempt[timing].keys.each do |attempt_number|
        @subsplit_durations_by_attempt[timing][attempt_number] = @subsplit_durations_by_attempt[timing][attempt_number].sum
      end
    end

    @subsplit_durations_by_attempt
  end

    def percentile(values_sorted, percent)
    return values_sorted[0] if values_sorted.length == 1
    k = (percent * (values_sorted.length - 1) + 1).floor - 1
    f = (percent * (values_sorted.length - 1) + 1).modulo(1)

    values_sorted[k] + (f * (values_sorted[k+1] - values_sorted[k]))
  end
end
