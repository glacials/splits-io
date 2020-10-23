class RemoveOldColumnsFromTwitchUserFollows < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      remove_column :twitch_user_follows, :from_user_id
      remove_column :twitch_user_follows, :to_user_id
    end
  end
end
