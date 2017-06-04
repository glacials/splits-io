class Api::V3::Detail::RunSerializer < Api::V3::ApplicationSerializer
  belongs_to :user, serializer: Api::V3::UserSerializer
  belongs_to :game, serializer: Api::V3::GameSerializer
  belongs_to :category, serializer: Api::V3::CategorySerializer
  has_one :time

  attributes :id, :path, :name, :program, :image_url, :created_at, :updated_at, :video_url, :splits, :attempts, :sum_of_best

  def splits
    object.segments.map do |segment|
      segment.shortest_duration_milliseconds = {duration: segment.shortest_duration_milliseconds / 1000}
      segment
      {
        name: segment.name,
        duration: (segment.duration_milliseconds || 0).to_f / 1000,
        finish_time: (segment.end_milliseconds || 0).to_f / 1000,
        best: {
          duration: (segment.shortest_duration_milliseconds || 0).to_f / 1000
        },
        history: segment.histories.map do |history|
          (history.duration_milliseconds || 0).to_f / 1000
        end,
        gold: segment.gold?,
        skipped: segment.skipped?,
        reduced: segment.reduced?
      }
    end
  end

  def sum_of_best
    object.sum_of_best.to_f
  end

  def name
    object.to_s
  end
end
