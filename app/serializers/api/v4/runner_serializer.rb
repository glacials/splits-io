class Api::V4::RunnerSerializer < Api::V4::ApplicationSerializer
  attributes :twitch_id, :name, :avatar, :created_at, :updated_at

  def twitch_id
    object.twitch_id.to_s
  end
end
