class Api::V4::UserSerializer < Api::V4::ApplicationSerializer
  attributes :twitch_id, :name, :avatar, :created_at, :updated_at

  private

  def avatar
    object.avatar.to_s
  end
end
