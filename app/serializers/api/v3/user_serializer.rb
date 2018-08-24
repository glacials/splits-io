class Api::V3::UserSerializer < Api::V3::ApplicationSerializer
  attributes :twitch_id, :name, :avatar, :created_at, :updated_at

  def twitch_id
    object.twitch.twitch_id
  end

  def avatar
    object.avatar.to_s
  end
end
