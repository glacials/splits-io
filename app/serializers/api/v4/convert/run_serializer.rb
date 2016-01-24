class Api::V4::Convert::RunSerializer < Api::V4::ApplicationSerializer
  has_one :game, serializer: Api::V4::GameSerializer
  has_one :category, serializer: Api::V4::CategorySerializer
  has_many :runners, serializer: Api::V4::RunnerSerializer

  attributes :id, :srdc_id, :name, :time, :program, :attempts, :image_url, :video_url, :created_at, :updated_at, :splits

  def created_at
    DateTime.now.utc.to_s(:iso8601)
  end

  def updated_at
    DateTime.now.utc.to_s(:iso8601)
  end

  def history
    object.history || []
  end

  def attempts
    object.attempts || 0
  end
end
