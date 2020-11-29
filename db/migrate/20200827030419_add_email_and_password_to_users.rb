class AddEmailAndPasswordToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email,           :string, null: true, index: {unique: true}
    add_column :users, :password_digest, :string, null: true

    User.includes(:twitch, :google).find_each do |user|
      user.update(email: [user.google, user.twitch].compact.map(&:email).first)
    end
  end
end
