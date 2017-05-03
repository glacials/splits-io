class CreateRivalries < ActiveRecord::Migration[4.2]
  def change
    create_table :rivalries do |t|
      t.belongs_to :category, index: true
      t.belongs_to :from_user, index: true
      t.belongs_to :to_user, index: true
    end
  end
end
