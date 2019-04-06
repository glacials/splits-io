class SegmentHistory < ApplicationRecord
  belongs_to :segment
  has_one :run, through: :segment

  # with_ends modifies the returned SegmentHistories to have realtime_end_ms and gametime_end_ms fields, which represent
  # the duration into the attempt when that specific segment history ended.
  #
  # It does this using a SQL window function to sum the attempts for the segments leading up to this one, for each one.
  # This is multiple orders of magnitude more efficient than loading these into Rails and doing it there, for n attempts
  # and m segments.
  def self.with_ends
    joins(:segment).select('
      segment_histories.*,
      CAST(
        sum(segment_histories.realtime_duration_ms) OVER(PARTITION BY attempt_number ORDER BY segments.segment_number)
        AS BIGINT
      ) AS realtime_end_ms,
      CAST(
        sum(segment_histories.gametime_duration_ms) OVER(PARTITION BY attempt_number ORDER BY segments.segment_number)
        AS BIGINT
      ) AS gametime_end_ms
    '.squish)
  end

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
