class MakeTwitchUsersUserIdUnique < ActiveRecord::Migration[5.2]
  def change
    remove_index :twitch_users, :user_id
    add_index    :twitch_users, :user_id, unique: true
  end
end
