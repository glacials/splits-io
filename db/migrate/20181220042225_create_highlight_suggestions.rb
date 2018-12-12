class CreateHighlightSuggestions < ActiveRecord::Migration[5.2]
  def change
    create_table :highlight_suggestions, id: :uuid do |t|
      t.belongs_to :run, foreign_key: true, unique: true, null: false
      t.text :url, null: false

      t.timestamps
    end
  end
end
