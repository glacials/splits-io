class Api::V4::Convert::RunSerializer < Api::V4::ApplicationSerializer
  has_one :game, serializer: Api::V4::GameSerializer
  has_one :category, serializer: Api::V4::CategorySerializer
  has_many :runners, serializer: Api::V4::RunnerSerializer

  attributes :id, :srdc_id, :time, :program, :attempts, :image_url, :video_url, :created_at, :updated_at, :splits, :history

  def id
    nil
  end

  def created_at
    DateTime.now.utc.to_s(:iso8601)
  end

  def updated_at
    DateTime.now.utc.to_s(:iso8601)
  end

  def history
    object.histories
  end

  def attempts
    object.attempts || 0
  end

  def runners
    if object.user.nil?
      []
    else
      [object.user]
    end
  end

  def splits
    object.segments.map do |segment|
      segment.realtime_shortest_duration_ms = {duration: segment.realtime_shortest_duration_ms / 1000}
      segment
      {
        name: segment.name,
        duration: (segment.realtime_duration_ms || 0).to_f / 1000,
        finish_time: (segment.realtime_end_ms || 0).to_f / 1000,
        best: {
          duration: (segment.realtime_shortest_duration_ms || 0).to_f / 1000
        },
        history: segment.histories.map do |history|
          (history.realtime_duration_ms || 0).to_f / 1000
        end,
        gold: segment.realtime_gold?,
        skipped: segment.realtime_skipped?,
        reduced: segment.realtime_reduced?
      }
    end
  end
end
