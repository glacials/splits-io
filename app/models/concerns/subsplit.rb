require 'active_support/concern'

module Subsplit
  extend ActiveSupport::Concern

  def first_subsplit?
    return false unless subsplit?
    return true if segment_number == 0
    !run.segments[segment_number - 1].name&.starts_with?('-')
  end

  def subsplit?
    return false unless name.present?
    /^[-\{]/.match?(name)
  end

  def subsplit_duration(timing)
    run.segments[first_subsplit.segment_number..last_subsplit.segment_number].map do |segment|
      segment.duration(timing)
    end.sum
  end

  def first_subsplit
    @first_subsplit ||=
      run.segments.where('segment_number <= ?', segment_number)
        .reorder(segment_number: :desc)
        .select { |segment| segment.first_subsplit? }.first
  end

  def last_subsplit
    run.segments
      .where('segment_number >= ?', segment_number)
      .where("name LIKE '{%'").first
  end

  def subsplit_title
    return nil unless subsplit?
    match = /\{(.+?)}/.match(last_subsplit.name)
    match[1] if match
  end

  def name_without_subsplit
    return name unless subsplit?
    /^(?:-|\{.*?}\s*)(.+)/.match(name)[1]
  end

  def display_name
    subsplit? ? name_without_subsplit : name
  end

  def subsplit_stats(timing)
    values = subsplit_durations_by_attempt[timing].values.sort
    mean = values.sum / subsplit_durations_by_attempt[timing].keys.length.to_f
    variance_sum = values.inject(0) { |accum, i| accum + (i-mean)**2 }
    sample_variance = variance_sum / (subsplit_durations_by_attempt[timing].keys.length - 1).to_f
    {
      standard_deviation: Math.sqrt(sample_variance),
      mean: mean,
      median: values[values.length / 2 + 1], # Not actual median, but matches the DB query
      percentiles: {
        10 => percentile(values, 0.1),
        90 => percentile(values, 0.9),
        99 => percentile(values, 0.99)
      }
    }
  end

  def subsplit_shortest_duration(timing)
    Duration.new(subsplit_durations_by_attempt[timing].values.min)
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

    run.segments[first_subsplit.segment_number..last_subsplit.segment_number].each do |segment|
      segment.histories.each do |history|
        previous_attempt = run.segments[segment.segment_number - 1]&.histories&.find { |attempt| attempt.attempt_number == history.attempt_number }
        @subsplit_durations_by_attempt[Run::REAL][history.attempt_number] << history.realtime_duration_ms unless history.realtime_duration_ms == 0 || previous_attempt&.realtime_duration_ms == 0
        @subsplit_durations_by_attempt[Run::GAME][history.attempt_number] << history.gametime_duration_ms unless history.gametime_duration_ms == 0 || previous_attempt&.gametime_duration_ms == 0
      end
    end
    puts @subsplit_durations_by_attempt
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
    k = (percent * (values_sorted.length - 1) + 1).floor - 1
    f = (percent * (values_sorted.length - 1) + 1).modulo(1)

    values_sorted[k] + (f * (values_sorted[k+1] - values_sorted[k]))
  end
end
