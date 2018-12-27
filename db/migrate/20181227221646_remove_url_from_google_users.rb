class RemoveUrlFromGoogleUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :google_users, :url
  end
end
