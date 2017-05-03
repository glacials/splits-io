class AllowNullInGameSrlIds < ActiveRecord::Migration[4.2]
  def change
    change_column_null :games, :srl_id, true
  end
end
