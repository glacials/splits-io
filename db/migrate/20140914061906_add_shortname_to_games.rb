class AddShortnameToGames < ActiveRecord::Migration
  def change
    add_column :games, :shortname, :string
  end
end
