class CreatePasswordResetTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :password_reset_tokens, id: :uuid do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :token, null: false

      t.timestamps
    end
    add_index :password_reset_tokens, :token, unique: true
  end
end
