class ValidateForeignKeysOnTwitchUserFollows < ActiveRecord::Migration[6.0]
  def change
    validate_foreign_key :twitch_user_follows, :twitch_users, column: :from_twitch_user_id
    validate_foreign_key :twitch_user_follows, :twitch_users, column: :to_twitch_user_id
  end
end
