class AddCategoryIdIndexToRuns < ActiveRecord::Migration[4.2]
  def change
    add_index :runs, :category_id
  end
end
