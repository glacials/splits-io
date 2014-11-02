class RemoveUniqueFromUserEmails < ActiveRecord::Migration
  def change
    remove_index :users, :email
    add_index :users, :email, unique: false
  end
end
