class Api::V4::RaceBlueprint < Blueprinter::Base
  fields :id, :status, :visibility, :notes, :started_at, :created_at, :updated_at
  field :path do |race, _|
    race.to_param
  end

  field :type do |race, _|
    race.type
  end

  field :join_token, if: ->(_, options) { options[:join_token] }

  association :owner, blueprint: Api::V4::UserBlueprint
  association :entrants, blueprint: Api::V4::EntrantBlueprint
  association :chat_messages, blueprint: Api::V4::ChatMessageBlueprint, if: ->(_, options) { options[:chat] }

  view :race do
    association :category, blueprint: Api::V4::CategoryBlueprint
  end

  view :bingo do
    field :card_url

    association :game, blueprint: Api::V4::GameBlueprint
  end

  view :randomizer do
    field :seed
    field :attachments do |race, _|
      race.attachments.map do |attachment|
        {
          id: attachment.id,
          created_at: attachment.created_at,
          filename: attachment.filename,
          url: Rails.application.routes.url_helpers.rails_blob_url(
            attachment,
            protocol: 'https',
            host: 'splits.io',
            disposition: 'attachment'
          ),
        }
      end
    end

    association :game, blueprint: Api::V4::GameBlueprint
  end
end
