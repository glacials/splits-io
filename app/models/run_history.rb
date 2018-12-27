class RunHistory < ApplicationRecord
  belongs_to :run

  def self.completed(timing)
    case timing
    when Run::REAL
      RunHistory.where('realtime_duration_ms > 0')
    when Run::GAME
      RunHistory.where('gametime_duration_ms > 0')
    end
  end

  # duration returns the total duration of this attempt.
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
