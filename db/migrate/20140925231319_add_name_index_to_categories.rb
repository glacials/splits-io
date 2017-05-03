class AddNameIndexToCategories < ActiveRecord::Migration[4.2]
  def change
    add_index :categories, :name
  end
end
