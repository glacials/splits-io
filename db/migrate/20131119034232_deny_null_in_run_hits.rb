class DenyNullInRunHits < ActiveRecord::Migration[4.2]
  def change
    change_column :runs, :hits, :integer, null: false, default: 0
  end
end
