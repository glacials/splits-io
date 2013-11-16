class AllowNullInRunUsers < ActiveRecord::Migration
  def change
    change_column :runs, :user_id, :integer, null: true
  end
end
