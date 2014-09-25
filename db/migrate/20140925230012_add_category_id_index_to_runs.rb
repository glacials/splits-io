class AddCategoryIdIndexToRuns < ActiveRecord::Migration
  def change
    add_index :runs, :category_id
  end
end
