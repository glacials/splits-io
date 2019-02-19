class CreateSpeedrunDotComCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :speedrun_dot_com_categories, id: :uuid do |t|
      t.belongs_to :category, foreign_key: true, index: {unique: true}, null: false

      t.string  :srdc_id,     null: false
      t.string  :name,        null: false
      t.string  :url,         null: false
      t.boolean :misc,        null: false
      t.string  :rules,       null: true
      t.integer :min_players, null: false
      t.integer :max_players, null: false

      t.timestamps
    end
  end
end
