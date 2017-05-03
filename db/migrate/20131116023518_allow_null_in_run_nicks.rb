class AllowNullInRunNicks < ActiveRecord::Migration[4.2]
  def change
    change_column :runs, :nick, :string, null: true
  end
end
