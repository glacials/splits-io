class GameBlueprint < Blueprinter::Base
  view :default do
    fields :name, :created_at, :updated_at

    field :shortname do |game, _options|
      game.srdc.try(:shortname) || game.srl.try(:shortname)
    end
  end

  view :api_v4 do
    include_view :default

    association :categories, blueprint: CategoryBlueprint, view: :api_v4, if: ->(_, options) { options[:toplevel] == :game }
  end

  view :api_v3 do
    include_view :default

    field :id

    association :categories, blueprint: CategoryBlueprint, view: :api_v3, if: ->(_, options) { options[:toplevel] == :game }
  end
end
