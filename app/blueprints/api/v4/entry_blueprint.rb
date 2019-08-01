class Api::V4::EntryBlueprint < Blueprinter::Base
  fields :id, :ghost, :readied_at, :finished_at, :forfeited_at, :created_at, :updated_at

  association :runner,  blueprint: Api::V4::UserBlueprint
  association :creator, blueprint: Api::V4::UserBlueprint
  association :run,     blueprint: Api::V4::RunBlueprint
end
