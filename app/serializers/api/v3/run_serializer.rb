class Api::V3::RunSerializer < Api::V3::ApplicationSerializer
  belongs_to :user, serializer: Api::V3::UserSerializer
  belongs_to :game, serializer: Api::V3::GameSerializer
  belongs_to :category, serializer: Api::V3::CategorySerializer

  attributes :id, :path, :name, :program, :image_url, :created_at, :updated_at,
             :video_url, :attempts, :sum_of_best, :time

  def sum_of_best
    (object.realtime_sum_of_best_ms || 0).to_f / 1000
  end

  def name
    object.to_s
  end

  def time
    (object.realtime_duration_ms || 0).to_f / 1000
  end
end
