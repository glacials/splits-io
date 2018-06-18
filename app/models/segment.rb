class Segment < ApplicationRecord
  belongs_to :run
  # dependent: :delete_all requires there be no child items that need to be deleted
  # If SegmentHistory is changed to have child records, change this back to just :destroy
  has_many :histories, class_name: 'SegmentHistory', dependent: :delete_all

  default_scope { order(segment_number: :asc) }

  def start_ms(timing)
    case timing
    when Run::REAL
      realtime_start_ms
    when Run::GAME
      gametime_start_ms
    end
  end

  def end_ms(timing)
    case timing
    when Run::REAL
      realtime_end_ms
    when Run::GAME
      gametime_end_ms
    end
  end

  def duration_ms(timing)
    case timing
    when Run::REAL
      realtime_duration_ms
    when Run::GAME
      gametime_duration_ms
    end
  end

  def shortest_duration_ms(timing)
    case timing
    when Run::REAL
      realtime_shortest_duration_ms
    when Run::GAME
      gametime_shortest_duration_ms
    end
  end

  def first?
    segment_number.zero?
  end

  def last?
    segment_number == run.segments.count - 1
  end

  def second_half?(timing)
    (end_ms(timing) - (duration_ms(timing) / 2)) > (run.duration_ms(timing) / 2)
  end

  def gold?(timing)
    case timing
    when Run::REAL
      realtime_gold?
    when Run::GAME
      gametime_gold?
    end
  end

  def reduced?(timing)
    case timing
    when Run::REAL
      realtime_reduced?
    when Run::GAME
      gametime_reduced?
    end
  end

  def skipped?(timing)
    case timing
    when Run::REAL
      realtime_skipped?
    when Run::GAME
      gametime_skipped?
    end
  end
end
