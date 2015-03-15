class Api::V4::UserSerializer < Api::V4::ApplicationSerializer
  attributes :twitch_id, :name, :avatar, :created_at, :updated_at
end
