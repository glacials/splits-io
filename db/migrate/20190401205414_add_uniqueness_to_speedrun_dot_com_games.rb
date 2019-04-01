class AddUniquenessToSpeedrunDotComGames < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    remove_index :speedrun_dot_com_games, :shortname

    add_index :speedrun_dot_com_games, :shortname, unique: true, algorithm: :concurrently
    add_index :speedrun_dot_com_games, :srdc_id,   unique: true, algorithm: :concurrently
  end
end
