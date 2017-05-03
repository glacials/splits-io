class AddTwitchTokenToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :twitch_token, :string
  end
end
