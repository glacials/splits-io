class Api::V2::CategorySerializer < Api::V2::ApplicationSerializer
  attributes :id, :name, :created_at, :updated_at
end
