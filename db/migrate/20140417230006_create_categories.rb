class CreateCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :categories do |t|
      t.belongs_to :game, index: true
      t.string :name

      t.timestamps
    end
  end
end
