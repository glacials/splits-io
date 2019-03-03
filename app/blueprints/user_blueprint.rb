class UserBlueprint < Blueprinter::Base
  view :default do
    fields :name, :avatar, :created_at, :updated_at

    field :twitch_id do |runner, _options|
      runner.twitch.try(:twitch_id)
    end
  end

  view :api_v4 do
    include_view :default

    field :display_name do |runner, _options|
      runner.to_s
    end
  end

  view :api_v3 do
    include_view :default
  end
end
