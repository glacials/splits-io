class AddNameIndexToGames < ActiveRecord::Migration
  def change
    add_index :games, :name
  end
end
