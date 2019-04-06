class Segment < ApplicationRecord
  belongs_to :run
  # dependent: :delete_all requires there be no child items that need to be deleted
  # If SegmentHistory is changed to have child records, change this back to just :destroy
  has_many :histories, -> { order(attempt_number: :asc) }, class_name: 'SegmentHistory', dependent: :delete_all

  # start returns the Duration between the start of the run and the start of this segment. For example, the first
  # segment of the run would have a start of 0. The second segment would have a start equal to the duration of the first
  # segment. The last segment would have a start equal to the duration of the run minus the duration of the last
  # segment.
  def start(timing)
    case timing
    when Run::REAL
      Duration.new(realtime_start_ms)
    when Run::GAME
      Duration.new(gametime_start_ms)
    end
  end

  # start_ms is deprecated. Use start instead, which returns a Duration type.
  def start_ms(timing)
    case timing
    when Run::REAL
      realtime_start_ms
    when Run::GAME
      gametime_start_ms
    end
  end

  # end returns the Duration between the start of the run and the end of this segment. For example, the first segment of
  # the run would have an end equal to its own duration. The second segment would have an equal to the sum of the firs
  # two segments' duraitons. The last segment would have an end equal to the duration of the run.
  def end(timing)
    case timing
    when Run::REAL
      Duration.new(realtime_end_ms)
    when Run::GAME
      Duration.new(gametime_end_ms)
    end
  end

  # end_ms is deprecated. Use end instead, which returns a Duration type.
  def end_ms(timing)
    case timing
    when Run::REAL
      realtime_end_ms
    when Run::GAME
      gametime_end_ms
    end
  end

  # duration returns the Duration between the start of this segment and the end of this segment.
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

  # shortest_duration returns the shortest Duration recorded in these splits.
  def shortest_duration(timing)
    case timing
    when Run::REAL
      Duration.new(realtime_shortest_duration_ms)
    when Run::GAME
      Duration.new(gametime_shortest_duration_ms)
    end
  end

  # shortest_duration_ms is deprecated. Use shortest_duration instead, which returns a Duration type.
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

  # gold? returns something truthy if this segment's PB time is the fastest (or tied for the fastest) ever recorded by
  # this runner, or something falsey otherwise.
  def gold?(timing)
    case timing
    when Run::REAL
      realtime_gold?
    when Run::GAME
      gametime_gold?
    end
  end

  # reduced? returns something truthy if the split preceding (or starting, depending on how you look at it) this segment
  # was skipped, or something falsey otherwise.
  #
  # Something truthy means the "duration" of this segment is artificially long. For example, in a run with segments a,
  # b, and c, with splits start->a, a->b, b->c, and c->finish, if the b->c split was skipped, the "duration" of c will
  # absorb the duration of b, causing it to effectively be a b+c segment started by an a->b split and ended by a c->end
  # split.
  #
  # This has several negative impacts to analytics for the run, such as artificially inflating average and worst times
  # for c. Because of this, reduced segments should generally be excluded from analytics except for display purposes.
  def reduced?(timing)
    case timing
    when Run::REAL
      realtime_reduced?
    when Run::GAME
      gametime_reduced?
    end
  end

  # skipped? returns something truthy if the split ending this segment was skipped, or something falsey otherwise.
  #
  # When a segment's ending split is skipped, the segment's duration will generally be 0 or nil. The duration will be
  # absorbed into the following segment. See reduced? for further comments on how, and on what effects this has.
  def skipped?(timing)
    case timing
    when Run::REAL
      realtime_skipped?
    when Run::GAME
      gametime_skipped?
    end
  end

  def to_s
    name
  end

  def history_stats(timing)
    run.segment_history_stats(timing)[id]
  end
end
