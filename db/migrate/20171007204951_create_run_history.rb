class CreateRunHistory < ActiveRecord::Migration[5.0]
  def change
    create_table :run_histories, id: :uuid do |t|
      t.belongs_to :run, foreign_key: true
      t.integer :attempt_number
      t.integer :realtime_duration_ms
      t.integer :gametime_duration_ms

      t.timestamps
    end
  end
end
