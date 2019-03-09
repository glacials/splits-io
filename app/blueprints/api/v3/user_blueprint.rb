class Api::V3::UserBlueprint < Blueprinter::Base
  fields :name, :avatar, :created_at, :updated_at

  field :twitch_id do |user, _|
    user.twitch.try(:twitch_id)
  end
end
