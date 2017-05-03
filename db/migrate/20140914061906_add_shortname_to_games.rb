class AddShortnameToGames < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :shortname, :string
  end
end
