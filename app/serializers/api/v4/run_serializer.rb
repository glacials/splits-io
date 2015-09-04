class Api::V4::RunSerializer < Api::V4::ApplicationSerializer
  has_one :game, serializer: Api::V4::GameSerializer
  has_one :category, serializer: Api::V4::CategorySerializer
  has_many :runners, serializer: Api::V4::RunnerSerializer

  attributes :id, :srdc_id, :name, :time, :program, :attempts, :image_url, :created_at, :updated_at, :video_url

  private

  def id
    object.id36
  end
end
