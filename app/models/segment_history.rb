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

  def self.without_statistically_invalid_histories_for_run(run, timing)
    case timing
    when Run::REAL
      joins(SegmentHistory.sanitize_sql_array [%Q{
        LEFT JOIN (
          SELECT segment_histories.id AS id,
            segment_histories.attempt_number AS attempt_number,
            segments.segment_number as segment_number
          FROM segment_histories
          INNER JOIN segments ON segments.id = segment_histories.segment_id
            WHERE segments.run_id = :run_id
            AND NOT ((segment_histories.realtime_duration_ms = 0
              OR segment_histories.realtime_duration_ms IS NULL))
        ) AS other_histories ON
          other_histories.attempt_number = segment_histories.attempt_number
          AND other_histories.segment_number = segments_segment_histories.segment_number - 1}.squish, run_id: run.id])
    when Run::GAME
      joins(SegmentHistory.sanitize_sql_array [%Q{
        LEFT JOIN (
          SELECT segment_histories.id AS id,
            segment_histories.attempt_number AS attempt_number,
            segments.segment_number as segment_number
          FROM segment_histories
          INNER JOIN segments ON segments.id = segment_histories.segment_id
            WHERE segments.run_id = :run_id
            AND NOT ((segment_histories.gametime_duration_ms = 0
              OR segment_histories.gametime_duration_ms IS NULL))
        ) AS other_histories ON
          other_histories.attempt_number = segment_histories.attempt_number
          AND other_histories.segment_number = segments_segment_histories.segment_number - 1}.squish, run_id: run.id])
    else
      raise 'Unsupported timing'
    end
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
