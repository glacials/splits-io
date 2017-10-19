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

  def duration_ms(time_type)
    case time_type
    when Run::REAL
      realtime_duration_ms
    when Run::GAME
      gametime_duration_ms
    end
  end
end
