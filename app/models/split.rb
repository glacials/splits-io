class Split
  attr_accessor :name, :duration, :finish_time, :best, :history, :gold, :skipped, :reduced

  def initialize(h = {})
    @name = h[:name]
    @duration = h[:duration]
    @finish_time = h[:finish_time]
    @best = h[:best]
    @history = h[:history]
    @gold = h[:gold?] || h[:gold]
    @skipped = h[:skipped?] || h[:skipped]
    @reduced = h[:reduced?] || h[:reduced]
  end

  def gold?
    gold
  end

  def skipped?
    skipped
  end

  def reduced?
    reduced
  end

  def to_h
    {
      name: name,
      duration: duration,
      finish_time: finish_time,
      best: best,
      gold?: gold,
      skipped?: skipped,
      reduced?: reduced,
      history: history
    }.compact
  end

  def serializable_hash
    {
      name: name,
      duration: duration,
      finish_time: finish_time,
      best: best.try(:serializable_hash),
      gold?: gold,
      skipped?: skipped,
      history: history
    }.compact
  end
end
