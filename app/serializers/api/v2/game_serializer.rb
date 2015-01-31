class Api::V2::GameSerializer < Api::V2::ApplicationSerializer
  has_many :categories, serializer: Api::V2::CategorySerializer

  attributes :id, :name, :shortname, :created_at, :updated_at
end
