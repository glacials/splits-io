class MoveTwitchDataOutOfUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :twitch_users, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.string   :access_token,      null: false
      t.string   :name,              null: false
      t.string   :display_name,      null: false
      t.string   :twitch_id,         null: false, index: {unique: true}
      t.string   :email,             null: true
      t.string   :avatar,            null: false
      t.datetime :follows_synced_at, null: false, default: 100.years.ago

      t.timestamps
    end

    User.find_each do |user|
      TwitchUser.create(
        user:              user,
        access_token:      user.twitch_token,
        display_name:      user.twitch_display_name,
        twitch_id:         user.twitch_id,
        email:             user.email,
        avatar:            user.avatar,
        follows_synced_at: user.twitch_user_follows_checked_at || 100.years.ago
      )
    end

    remove_column :users, :twitch_token
    remove_column :users, :twitch_display_name
    remove_column :users, :twitch_id
    remove_column :users, :avatar
    remove_column :users, :email
    remove_column :users, :twitch_user_follows_checked_at
  end
end
