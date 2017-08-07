class CreatePatreonUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :patreon_users, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.string   :access_token,      null: false
      t.string   :refresh_token,     null: false
      t.string   :full_name,         null: false
      t.string   :patreon_id,        null: false
      t.integer  :pledge_cents,      null: false
      t.datetime :pledge_created_at, null: true

      t.timestamps
    end
  end
end
