class Split
  attr_accessor(
    :id,
    :name,
    :indexed_history,
    :realtime_duration,
    :realtime_start,
    :realtime_end,
    :realtime_best,
    :realtime_history,
    :realtime_gold,
    :realtime_skipped,
    :realtime_reduced,
    :gametime_duration,
    :gametime_start,
    :gametime_end,
    :gametime_best,
    :gametime_gold,
    :gametime_skipped,
    :gametime_reduced
  )

  def initialize(h = {})
    @id   = h[:id]
    @name = h[:name]

    @indexed_history = h[:indexed_history]

    @realtime_duration = h[:realtime_duration]
    @realtime_start    = h[:realtime_start]
    @realtime_end      = h[:realtime_end]
    @realtime_best     = h[:realtime_best]
    @realtime_history  = h[:realtime_history]
    @realtime_gold     = h[:realtime_gold?]    || h[:realtime_gold]    || false
    @realtime_skipped  = h[:realtime_skipped?] || h[:realtime_skipped] || false
    @realtime_reduced  = h[:realtime_reduced?] || h[:realtime_reduced] || false

    @gametime_duration = h[:gametime_duration]
    @gametime_start    = h[:gametime_start]
    @gametime_end      = h[:gametime_end]
    @gametime_best     = h[:gametime_best]
    @gametime_gold     = h[:gametime_gold?]    || h[:gametime_gold]    || false
    @gametime_skipped  = h[:gametime_skipped?] || h[:gametime_skipped] || false
    @gametime_reduced  = h[:gametime_reduced?] || h[:gametime_reduced] || false
  end

  def realtime_gold?
    realtime_gold || false
  end

  def realtime_skipped?
    realtime_skipped || false
  end

  def realtime_reduced?
    realtime_reduced || false
  end

  def gametime_gold?
    gametime_gold || false
  end

  def gametime_skipped?
    gametime_skipped || false
  end

  def gametime_reduced?
    gametime_reduced || false
  end

  def to_h
    {
      id:   id,
      name: name,

      realtime_duration: realtime_duration,
      realtime_start:    realtime_start,
      realtime_end:      realtime_end,
      realtime_best:     realtime_best,
      realtime_gold:     realtime_gold,
      realtime_skipped:  realtime_skipped,

      gametime_duration: gametime_duration,
      gametime_start:    gametime_start,
      gametime_end:      gametime_end,
      gametime_best:     gametime_best,
      gametime_gold:     gametime_gold,
      gametime_skipped:  gametime_skipped
    }.compact
  end

  def serializable_hash
    {
      id:   id,
      name: name,

      realtime_duration: realtime_duration,
      realtime_start:    realtime_start,
      realtime_end:      realtime_end,
      realtime_best:     realtime_best.try(:serializable_hash),
      realtime_gold:     realtime_gold,
      realtime_skipped:  realtime_skipped,

      gametime_duration: gametime_duration,
      gametime_start:    gametime_start,
      gametime_end:      gametime_end,
      gametime_best:     gametime_best.try(:serializable_hash),
      gametime_gold:     gametime_gold,
      gametime_skipped:  gametime_skipped
    }.compact
  end
end
