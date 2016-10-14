class Api::V4::RunSerializer < Api::V4::ApplicationSerializer
  attributes :id, :srdc_id, :name, :time, :program, :attempts, :image_url, :created_at, :updated_at, :video_url

  has_one :game, serializer: Api::V4::GameSerializer
  has_one :category, serializer: Api::V4::CategorySerializer
  has_many :runners, serializer: Api::V4::RunnerSerializer

  def runners
    if object.user.nil?
      []
    else
      [object.user]
    end
  end
end
