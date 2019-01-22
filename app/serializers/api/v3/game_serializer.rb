class Api::V3::GameSerializer < Api::V3::ApplicationSerializer
  has_many :categories, serializer: Api::V3::CategorySerializer

  attributes :id, :name, :shortname, :created_at, :updated_at

  def shortname
    object.srdc.try(:shortname)
  end
end
