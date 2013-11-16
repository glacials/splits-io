class UndoAllowNullInRunNicks < ActiveRecord::Migration
  def change
    change_column :runs, :nick, :string
  end
end
