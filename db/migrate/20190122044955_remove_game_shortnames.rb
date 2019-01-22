class RemoveGameShortnames < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :shortname, :string
  end
end
