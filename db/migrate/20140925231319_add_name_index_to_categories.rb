class AddNameIndexToCategories < ActiveRecord::Migration
  def change
    add_index :categories, :name
  end
end
