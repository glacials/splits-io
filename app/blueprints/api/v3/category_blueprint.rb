class Api::V3::CategoryBlueprint < Blueprinter::Base
  fields :id, :name, :created_at, :updated_at

  association :game, blueprint: Api::V3::GameBlueprint, if: ->(_, options) { options[:toplevel] == :category }
end
