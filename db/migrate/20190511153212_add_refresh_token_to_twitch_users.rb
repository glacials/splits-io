class AddRefreshTokenToTwitchUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :twitch_users, :refresh_token, :string, null: true
  end
end
