class CreateRunLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :run_likes, id: :uuid do |t|
      t.belongs_to :run,  foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps
    end

    add_index :run_likes, [:run_id, :user_id], unique: true
  end
end
