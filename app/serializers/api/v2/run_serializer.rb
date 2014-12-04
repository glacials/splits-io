class Api::V2::RunSerializer < ActiveModel::Serializer
  has_one :user, serializer: Api::V2::UserSerializer
  has_one :game, serializer: Api::V2::GameSerializer
  has_one :category, serializer: Api::V2::CategorySerializer
  has_many :splits

  attributes :id, :name, :time, :program, :image_url, :created_at, :updated_at
end
