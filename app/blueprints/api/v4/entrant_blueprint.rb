class Api::V4::EntrantBlueprint < Blueprinter::Base
  fields :id, :readied_at, :finished_at, :forfeited_at, :created_at, :updated_at

  association :user, blueprint: Api::V4::UserBlueprint
  association :run, blueprint: Api::V4::RunBlueprint
end
