class Api::V3::Detail::RunSerializer < Api::V3::ApplicationSerializer
  belongs_to :user, serializer: Api::V3::UserSerializer
  belongs_to :game, serializer: Api::V3::GameSerializer
  belongs_to :category, serializer: Api::V3::CategorySerializer
  has_one :time

  attributes :id, :path, :name, :program, :image_url, :created_at, :updated_at, :video_url, :splits, :attempts, :sum_of_best

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

  def sum_of_best
    object.realtime_sum_of_best_s.to_f
  end

  def name
    object.to_s
  end
end
