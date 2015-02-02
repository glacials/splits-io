class Api::V2::RunWithSplitsSerializer < Api::V2::ApplicationSerializer
  has_one :user, serializer: Api::V2::UserSerializer
  has_one :game, serializer: Api::V2::GameSerializer
  has_one :category, serializer: Api::V2::CategorySerializer

  attributes :id, :path, :name, :time, :program, :image_url, :created_at, :updated_at
end
