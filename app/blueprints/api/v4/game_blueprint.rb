class Api::V4::GameBlueprint < Blueprinter::Base
  fields :name, :created_at, :updated_at

  field :id do |game, _|
    game.id.to_s
  end

  field :shortname do |game, _|
    game.srdc.try(:shortname) || game.srl.try(:shortname)
  end

  field :srdc_id do |game, _|
    game.srdc&.srdc_id
  end

  field :cover_url do |game, _|
    game.srdc&.cover_url
  end

  association :categories, blueprint: Api::V4::CategoryBlueprint, if: ->(_, _, options) { options[:toplevel] == :game }
end
