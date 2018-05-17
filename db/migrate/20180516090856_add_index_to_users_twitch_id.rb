class AddIndexToUsersTwitchId < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :twitch_id
  end
end
