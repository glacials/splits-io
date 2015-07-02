class AllowNullInGameSrlIds < ActiveRecord::Migration
  def change
    change_column_null :games, :srl_id, true
  end
end
