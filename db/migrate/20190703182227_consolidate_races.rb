class ConsolidateRaces < ActiveRecord::Migration[6.0]
  def change
    drop_table 'randomizers', id: :uuid do |t|
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

    drop_table 'bingos', id: :uuid do |t|
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

    safety_assured { add_reference :races, :game, null: true }

    safety_assured { rename_column :entries,       :raceable_id, :race_id }
    safety_assured { rename_column :chat_messages, :raceable_id, :race_id }

    safety_assured { remove_column :chat_messages, :raceable_type, :string }
    safety_assured { remove_column :entries,       :raceable_type, :string }

    change_column_null :races, :category_id, true
  end
end
