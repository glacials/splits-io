class CreateSegments < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'
    create_table :segments, id: :uuid do |t|
      t.belongs_to :run, foreign_key: true, null: false
      t.integer :segment_number, null: false
      t.integer :duration_milliseconds, null: false
      t.integer :start_milliseconds, null: false
      t.integer :end_milliseconds, null: false
      t.integer :shortest_duration_milliseconds, null: false
      t.string :name, null: false
      t.boolean :gold, null: false
      t.boolean :reduced, null: false
      t.boolean :skipped, null: false

      t.timestamps
    end
  end
end
