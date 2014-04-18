class AddCategoryToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :category_id, :int
  end
end
