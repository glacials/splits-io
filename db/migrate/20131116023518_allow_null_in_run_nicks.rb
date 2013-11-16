class AllowNullInRunNicks < ActiveRecord::Migration
  def change
    change_column :runs, :nick, :string, null: true
  end
end
