class RemoveUniqueFromUserEmails < ActiveRecord::Migration[4.2]
  def change
    remove_index :users, :email
    add_index :users, :email, unique: false
  end
end
