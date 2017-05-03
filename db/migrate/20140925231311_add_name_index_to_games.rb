class AddNameIndexToGames < ActiveRecord::Migration[4.2]
  def change
    add_index :games, :name
  end
end
