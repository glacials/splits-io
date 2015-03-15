class Api::V4::CategorySerializer < Api::V4::ApplicationSerializer
  attributes :id, :name, :created_at, :updated_at
end
