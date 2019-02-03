class RunnerSerializer < Panko::Serializer
  attributes :twitch_id, :name, :display_name, :avatar, :created_at, :updated_at

  def twitch_id
    object.twitch.try(:twitch_id).try(:to_s)
  end

  def display_name
    object.to_s
  end

  def avatar
    object.avatar
  end
end
