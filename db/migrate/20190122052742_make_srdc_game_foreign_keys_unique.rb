class MakeSrdcGameForeignKeysUnique < ActiveRecord::Migration[5.2]
  def change
    remove_index :speedrun_dot_com_games, :game_id
    add_index :speedrun_dot_com_games, :game_id, unique: true
  end
end
