class Api::V4::ChatMessageBlueprint < Blueprinter::Base
  fields :body, :entrant

  association :user, blueprint: Api::V4::UserBlueprint
end
