class AllowNullInGameSrlIds < ActiveRecord::Migration
  def change
    change_column :games, :integer, null: true
  end
end
