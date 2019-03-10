class Api::V4::UserBlueprint < Blueprinter::Base
  fields :name, :avatar, :created_at, :updated_at

  field :display_name do |user, _|
    user.to_s
  end

  field :twitch_id do |user, _|
    user.twitch.try(:twitch_id)
  end
end
