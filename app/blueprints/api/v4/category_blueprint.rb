class Api::V4::CategoryBlueprint < Blueprinter::Base
  fields :name, :created_at, :updated_at

  field :id do |category, _|
    category.id.to_s
  end

  association :game, blueprint: Api::V4::GameBlueprint, if: ->(_, options) { options[:toplevel] == :category }
end
