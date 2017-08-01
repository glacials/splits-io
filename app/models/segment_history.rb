class SegmentHistory < ApplicationRecord
  belongs_to :segment
  has_one :run, through: :segment

  def duration_ms(time_type)
    case time_type
    when Run::REAL
      realtime_duration_ms
    when Run::GAME
      gametime_duration_ms
    end
  end
end
