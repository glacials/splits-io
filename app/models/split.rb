class Split
  attr_accessor :name, :duration, :start_time, :finish_time, :best, :history, :gold, :skipped, :reduced

  def initialize(h = {})
    @name = h[:name]
    @duration = h[:duration]
    @start_time = h[:start_time]
    @finish_time = h[:finish_time]
    @best = h[:best]
    @history = h[:history]
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
      name: name,
      duration: duration,
      start_time: start_time,
      finish_time: finish_time,
      best: best.try(:serializable_hash),
      gold: gold,
      skipped: skipped,
    }.compact
  end
end
