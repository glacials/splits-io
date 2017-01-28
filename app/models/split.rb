class Split
  attr_accessor :id, :name, :duration, :start_time, :finish_time, :best, :history, :indexed_history, :gold, :skipped, :reduced

  def initialize(h = {})
    @id = h[:id]
    @name = h[:name]
    @duration = h[:duration]
    @start_time = h[:start_time]
    @finish_time = h[:finish_time]
    @best = h[:best]
    @history = h[:history]
    @indexed_history = h[:indexed_history]
    @gold = h[:gold?] || h[:gold] || false
    @skipped = h[:skipped?] || h[:skipped] || false
    @reduced = h[:reduced?] || h[:reduced] || false
  end

  def gold?
    gold || false
  end

  def skipped?
    skipped || false
  end

  def reduced?
    reduced || false
  end

  def to_h
    {
      id: id,
      name: name,
      duration: duration,
      start_time: start_time,
      finish_time: finish_time,
      best: best,
      gold: gold,
      skipped: skipped,
    }.compact
  end

  def serializable_hash
    {
      id: id,
      name: name,
      duration: duration,
      start_time: start_time,
      finish_time: finish_time,
      best: best.try(:serializable_hash),
      gold: gold,
      skipped: skipped,
    }.compact
  end

  def dynamodb_history
    attrs = 'attempt_number, duration_seconds'

    resp = $dynamodb_segment_histories.query(
      key_condition_expression: 'segment_id = :segment_id',
      expression_attribute_values: {
        ':segment_id' => id,
      },
      projection_expression: attrs
    )

    attempts = resp.items

    attempts.each do |attempt|
      attempt['attempt_number'] = attempt['attempt_number'].to_i
      attempt['duration_seconds'] = attempt['duration_seconds'].to_f
    end

    return attempts
  end
end
