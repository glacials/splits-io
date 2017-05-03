class AddShortnameIndexToGames < ActiveRecord::Migration[4.2]
  def change
    add_index :games, :shortname
  end
end
