class AddCategoryToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :category_id, :int
  end
end
