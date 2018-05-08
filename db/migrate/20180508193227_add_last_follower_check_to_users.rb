class AddLastFollowerCheckToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :follows_checked_at, :datetime
  end
end
