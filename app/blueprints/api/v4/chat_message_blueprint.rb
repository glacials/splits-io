class Api::V4::ChatMessageBlueprint < Blueprinter::Base
  fields :body, :entrant, :created_at, :updated_at

  association :user, blueprint: Api::V4::UserBlueprint
end
