class AddSrlIdToGames < ActiveRecord::Migration
  def change
    add_column :games, :srl_id, :integer
  end
end
