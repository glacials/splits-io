class CreateFollows < ActiveRecord::Migration[5.1]
  def change
    create_table :follows do |t|
      t.belongs_to :from_user, index: true
      t.belongs_to :to_user, index: true
      t.timestamps
    end
  end
end
