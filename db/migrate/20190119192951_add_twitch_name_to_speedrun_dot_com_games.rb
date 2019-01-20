class AddTwitchNameToSpeedrunDotComGames < ActiveRecord::Migration[5.2]
  def change
    add_column :speedrun_dot_com_games, :twitch_name, :string, null: true
  end
end
