class Api::V4::RaceBlueprint < Blueprinter::Base
  fields :id, :status, :visibility, :notes, :started_at, :created_at, :updated_at

  field :type do |race, _|
    race.type
  end

  association :entrants, blueprint: Api::V4::EntrantBlueprint
  association :chat_messages, blueprint: Api::V4::ChatMessageBlueprint, if: ->(_, options) { options[:chat] }

  view :race do
    association :category, blueprint: Api::V4::CategoryBlueprint
  end

  view :bingo do
    field :card

    association :game, blueprint: Api::V4::GameBlueprint
  end

  view :randomizer do
    field :seed

    association :game, blueprint: Api::V4::GameBlueprint
  end
end
