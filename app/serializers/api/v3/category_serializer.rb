class Api::V3::CategorySerializer < Api::V3::ApplicationSerializer
  attributes :id, :name, :created_at, :updated_at
end
