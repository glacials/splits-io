class DenyNullInRunHits < ActiveRecord::Migration
  def change
    change_column :runs, :hits, :integer, null: false, default: 0
  end
end
