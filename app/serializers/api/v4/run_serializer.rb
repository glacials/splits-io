class Api::V4::RunSerializer < Api::V4::ApplicationSerializer
  attributes :id, :srdc_id, :realtime_duration_ms, :gametime_duration_ms, :default_timing,
             :realtime_sum_of_best_ms, :gametime_sum_of_best_ms, :program, :attempts, :image_url,
             :created_at, :updated_at, :video_url

  has_one :game, serializer: Api::V4::GameSerializer
  has_one :category, serializer: Api::V4::CategorySerializer
  has_many :runners, serializer: Api::V4::RunnerSerializer
  has_many :histories, serializer: Api::V4::RunHistorySerializer
  has_many :segments, serializer: Api::V4::SegmentSerializer

  def id
    object.id36
  end

  def runners
    if object.user.nil?
      []
    else
      [object.user]
    end
  end
end
