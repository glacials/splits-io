class SegmentHistory < ApplicationRecord
  belongs_to :segment
  has_one :run, through: :segment

  # duration returns the duration of this segment.
  def duration(timing)
    case timing
    when Run::REAL
      Duration.new(realtime_duration_ms)
    when Run::GAME
      Duration.new(gametime_duration_ms)
    end
  end

  # duration_ms is deprecated. Use duration instead, which returns a Duration type.
  def duration_ms(timing)
    case timing
    when Run::REAL
      realtime_duration_ms
    when Run::GAME
      gametime_duration_ms
    end
  end
end
