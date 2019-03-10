class Api::V4::GameBlueprint < Blueprinter::Base
  fields :name, :created_at, :updated_at

  field :shortname do |game, _|
    game.srdc.try(:shortname) || game.srl.try(:shortname)
  end

  association :categories, blueprint: Api::V4::CategoryBlueprint, if: ->(_, options) { options[:toplevel] == :game }
end
