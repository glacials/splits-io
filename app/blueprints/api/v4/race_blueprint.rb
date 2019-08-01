class Api::V4::RaceBlueprint < Blueprinter::Base
  fields :id, :visibility, :notes, :started_at, :created_at, :updated_at
  field :path do |race, _|
    Rails.application.routes.url_helpers.race_path(race)
  end

  field :join_token do |race, options|
    options[:join_token] ? race.join_token : nil
  end

  association :owner, blueprint: Api::V4::UserBlueprint
  association :entries, blueprint: Api::V4::EntryBlueprint
  association :chat_messages, blueprint: Api::V4::ChatMessageBlueprint do |race, options|
    options[:chat] ? race.chat_messages.order(created_at: :desc).limit(100) : []
  end

  association :game, blueprint: Api::V4::GameBlueprint
  association :category, blueprint: Api::V4::CategoryBlueprint

  field :attachments do |race, _|
    race.attachments.map do |attachment|
      {
        id:         attachment.id,
        created_at: attachment.created_at,
        filename:   attachment.filename.to_s,
        url:        Rails.application.routes.url_helpers.rails_blob_url(
          attachment,
          protocol:    'https',
          host:        'splits.io',
          disposition: 'attachment'
        )
      }
    end
  end
end
