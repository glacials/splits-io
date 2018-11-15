class AddUrlToTwitchUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :twitch_users, :url, :string

    TwitchUser.find_each do |twitch|
      twitch.update(url: "https://www.twitch.tv/#{twitch.name}")
    end

    change_column :twitch_users, :url, :string, null: false
  end
end
