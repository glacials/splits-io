class MakeGoogleUsersLastNameNullable < ActiveRecord::Migration[5.2]
  def change
    safety_assured { change_column :google_users, :last_name, :string, null: true }
  end
end
