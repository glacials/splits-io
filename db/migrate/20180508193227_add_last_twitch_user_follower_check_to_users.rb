class AddLastTwitchUserFollowerCheckToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :twitch_user_follows_checked_at, :datetime
  end
end
