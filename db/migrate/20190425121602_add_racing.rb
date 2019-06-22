class AddRacing < ActiveRecord::Migration[6.0]
  def change
    create_table :races, id: :uuid do |t|
      t.belongs_to :category, foreign_key: true, null: false
      t.belongs_to :user,     foreign_key: true, null: false

      t.integer  :visibility,  null: false, default: 0
      t.string   :join_token,  null: false
      t.string   :notes,       null: true

      # The limit param changes the precision of the datetime; 3 is millisecond accuracy
      t.datetime :started_at, limit: 3, null: true
      t.datetime :created_at, limit: 3, null: false
      t.datetime :updated_at, limit: 3, null: false
    end

    create_table :bingos, id: :uuid do |t|
      t.belongs_to :game, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false

      t.integer  :visibility,  null: false, default: 0
      t.string   :join_token,  null: false
      t.string   :notes,       null: true
      t.string   :card_url,    null: true

      t.datetime :started_at, limit: 3, null: true
      t.datetime :created_at, limit: 3, null: false
      t.datetime :updated_at, limit: 3, null: false
    end

    create_table :randomizers, id: :uuid do |t|
      t.belongs_to :game, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false

      t.integer  :visibility,  null: false, default: 0
      t.string   :join_token,  null: false
      t.string   :notes,       null: true
      t.string   :seed,        null: true

      t.datetime :started_at, limit: 3, null: true
      t.datetime :created_at, limit: 3, null: false
      t.datetime :updated_at, limit: 3, null: false
    end


    create_table :entries, id: :uuid do |t|
      t.references :raceable, polymorphic: true, index: true, type: :uuid
      t.belongs_to :user,     foreign_key: true, index: true

      t.datetime :readied_at,   limit: 3, null: true
      t.datetime :finished_at,  limit: 3, null: true
      t.datetime :forfeited_at, limit: 3, null: true
      t.datetime :created_at,   limit: 3, null: false
      t.datetime :updated_at,   limit: 3, null: false
    end

    create_table :chat_messages, id: :uuid do |t|
      t.belongs_to :raceable,  polymorphic: true, index: true, type: :uuid
      t.belongs_to :user,      foreign_key: true, null: false

      t.boolean :from_entrant, null: false
      t.text    :body,         null: false

      t.timestamps
    end
  end
end
