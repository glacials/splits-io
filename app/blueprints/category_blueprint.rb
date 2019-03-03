class CategoryBlueprint < Blueprinter::Base
  view :default do
    fields :name, :created_at, :updated_at
  end

  view :api_v4 do
    include_view :default
    field :id do |category, _options|
      category.id.to_s
    end

    association :game, blueprint: GameBlueprint, view: :api_v4, if: ->(_, options) { options[:toplevel] == :category }
  end

  view :api_v3 do
    include_view :default
    field :id

    association :game, blueprint: GameBlueprint, view: :api_v3, if: ->(_, options) { options[:toplevel] == :category }
  end
end
