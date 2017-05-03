class UndoAllowNullInRunNicks < ActiveRecord::Migration[4.2]
  def change
    change_column :runs, :nick, :string
  end
end
