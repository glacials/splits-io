class AllowNullInRunUsers < ActiveRecord::Migration[4.2]
  def change
    change_column :runs, :user_id, :integer, null: true
  end
end
