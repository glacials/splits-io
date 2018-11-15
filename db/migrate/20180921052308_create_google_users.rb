class CreateGoogleUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :google_users, id: :uuid do |t|
      t.belongs_to :user,                  null: false, unique: true, foreign_key: true
      t.string :google_id,                 null: false, index: {unique: true}
      t.string :access_token,              null: false
      t.datetime :access_token_expires_at, null: false, default: Time.new(1970)
      t.string :name,                      null: false
      t.string :email,                     null: false
      t.string :first_name,                null: false
      t.string :last_name,                 null: false
      t.string :avatar,                    null: false
      t.string :url,                       null: false
    end
  end
end
