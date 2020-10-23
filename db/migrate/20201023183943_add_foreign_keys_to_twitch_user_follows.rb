class AddForeignKeysToTwitchUserFollows < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :twitch_user_follows, :twitch_users, column: :from_twitch_user_id, validate: false
    add_foreign_key :twitch_user_follows, :twitch_users, column: :to_twitch_user_id,   validate: false
  end
end
