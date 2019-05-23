class Api::V4::EntrantBlueprint < Blueprinter::Base
  fields :readied_at, :finished_at, :forfeited_at, :created_at, :updated_at

  association :user, blueprint: Api::V4::UserBlueprint
end