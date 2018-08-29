class MoveTwitchDataOutOfUsers < ActiveRecord::Migration[5.2]
  def up
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
        twitch_id:         user.twitch_id,
        access_token:      user.twitch_token,
        name:              user.name,
        display_name:      user.twitch_display_name || user.name,
        email:             user.email,
        avatar:            user[:avatar] || TwitchUser.default_avatar,
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

  def down
    add_column :users, :twitch_token,                   :string
    add_column :users, :twitch_display_name,            :string
    add_column :users, :twitch_id,                      :string
    add_column :users, :avatar,                         :string
    add_column :users, :email,                          :string,  default: ''
    add_column :users, :twitch_user_follows_checked_at, :datetime

    TwitchUser.find_each do |twitch_user|
      twitch_user.user.update(
        twitch_id:                      twitch_user.twitch_id,
        twitch_token:                   twitch_user.access_token,
        name:                           twitch_user.name,
        twitch_display_name:            twitch_user.display_name,
        email:                          twitch_user.email,
        avatar:                         twitch_user.avatar,
        twitch_user_follows_checked_at: twitch_user.follows_synced_at
      )
    end

    drop_table :twitch_users
  end
end
