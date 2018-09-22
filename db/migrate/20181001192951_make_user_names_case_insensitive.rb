class MakeUserNamesCaseInsensitive < ActiveRecord::Migration[5.2]
  def up
    enable_extension :citext
    change_column :users, :name, :citext
    remove_index :users, :name
    add_index :users, :name, unique: true
  end

  def down
    change_column :users, :name, :text
  end
end
