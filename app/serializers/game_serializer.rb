class GameSerializer < Panko::Serializer
  attributes :name, :shortname, :created_at, :updated_at

  def shortname
    object.srdc.try(:shortname) || object.srl.try(:shortname)
  end
end
