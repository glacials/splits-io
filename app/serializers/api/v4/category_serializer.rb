class Api::V4::CategorySerializer < Api::V4::ApplicationSerializer
  attributes :id, :name, :created_at, :updated_at

  def id
    object.id.to_s
  end
end
