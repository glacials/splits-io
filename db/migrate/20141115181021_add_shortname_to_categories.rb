class AddShortnameToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :shortname, :string
  end
end
