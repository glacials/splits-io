class AddShortnameIndexToGames < ActiveRecord::Migration
  def change
    add_index :games, :shortname
  end
end
