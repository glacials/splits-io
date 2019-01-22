class Api::V4::GameSerializer < Api::V4::ApplicationSerializer
  has_many :categories, serializer: Api::V4::CategorySerializer

  attributes :name, :shortname, :created_at, :updated_at

  def shortname
    object.srdc.try(:shortname) || object.srl.try(:shortname)
  end
end
