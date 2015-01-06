class AllowNullInGameSrlIds < ActiveRecord::Migration
  def change
    change_column :games, :srl_id, :id, null: true
  end
end
