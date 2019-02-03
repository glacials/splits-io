class RunSerializer < Panko::Serializer
  attributes :id, :srdc_id, :realtime_duration_ms, :gametime_duration_ms, :default_timing,
             :realtime_sum_of_best_ms, :gametime_sum_of_best_ms, :program, :attempts, :image_url,
             :created_at, :updated_at, :video_url

  # Begin associations
  has_one :game, serializer: GameSerializer
  has_one :category, serializer: CategorySerializer
  has_many :runners, serializer: RunnerSerializer
  has_many :histories, serializer: RunHistorySerializer
  has_many :segments, serializer: SegmentSerializer

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
