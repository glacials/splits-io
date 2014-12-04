class Api::V2::CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at
end
