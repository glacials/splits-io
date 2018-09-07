class SegmentHistory < ApplicationRecord
  belongs_to :segment
  has_one :run, through: :segment

  # The recent scope allows us to run run.segments.includes(:recent_histories) to select the 100 most recent histories
  # for all segments without running n+1 queries. In short it applies a LIMIT to each set of JOINed segment_histories.
  # See: https://ksylvest.com/posts/2014-12-20/advanced-eager-loading-in-rails
  scope :recent, -> (count = 100) {
    rankings = "SELECT id, RANK() OVER(PARTITION BY segment_id ORDER BY id DESC) rank FROM segment_histories"

    joins("INNER JOIN (#{rankings}) rankings ON rankings.id = segment_histories.id")
      .where("rankings.rank < :count", count: count.next)
      .order(attempt_number: "DESC")
  }

  def duration_ms(time_type)
    case time_type
    when Run::REAL
      realtime_duration_ms
    when Run::GAME
      gametime_duration_ms
    end
  end
end
