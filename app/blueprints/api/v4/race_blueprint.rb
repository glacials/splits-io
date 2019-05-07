class Api::V4::RaceBlueprint < Blueprinter::Base
  fields :id, :status_text, :listed, :invite, :notes, :started_at, :created_at, :updated_at

  association :entrants, blueprint: Api::V4::EntrantBlueprint

  view :standard do
    association :category, blueprint: Api::V4::CategoryBlueprint
  end

  view :bingo do
    field :card do |race, _|
      race.started? ? race.card : nil
    end

    association :game, blueprint: Api::V4::GameBlueprint
  end

  view :randomizer do
    field :seed do |race, _|
      race.started? ? race.seed : nil
    end

    association :game, blueprint: Api::V4::GameBlueprint
  end
end
