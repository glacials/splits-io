class RunHistory < ApplicationRecord
  belongs_to :run

  scope :completed, (lambda do |timing|
    case timing
    when Run::REAL
      where('realtime_duration_ms > 0').count
    when Run::GAME
      where('gametime_duration_ms > 0').count
    end
  end)

  def duration_ms(time_type)
    case time_type
    when Run::REAL
      realtime_duration_ms
    when Run::GAME
      gametime_duration_ms
    end
  end
end
