class Api::V3::GameSerializer < ActiveModel::Serializer
  has_many :categories, serializer: Api::V3::CategorySerializer

  attributes :id, :name, :shortname, :srl_id, :created_at, :updated_at
end
