class AddTwitchTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitch_token, :string
  end
end
