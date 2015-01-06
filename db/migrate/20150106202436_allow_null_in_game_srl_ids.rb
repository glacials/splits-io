class AllowNullInGameSrlIds < ActiveRecord::Migration
  def change
    change_column :games, :srl_id, :integer, null: true
  end
end
