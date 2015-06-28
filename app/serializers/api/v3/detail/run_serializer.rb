class Api::V3::Detail::RunSerializer < Api::V3::ApplicationSerializer
  belongs_to :user, serializer: Api::V3::UserSerializer
  belongs_to :game, serializer: Api::V3::GameSerializer
  belongs_to :category, serializer: Api::V3::CategorySerializer
  has_one :time

  attributes :id, :path, :name, :program, :image_url, :created_at, :updated_at, :video_url, :splits
end
