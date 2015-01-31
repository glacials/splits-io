class Api::V2::UserSerializer < Api::V2::ApplicationSerializer
  attributes :id, :twitch_id, :name, :avatar, :created_at, :updated_at
end
