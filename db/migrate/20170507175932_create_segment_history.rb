class CreateSegmentHistory < ActiveRecord::Migration[5.0]
  def change
    create_table :segment_histories, id: :uuid do |t|
      t.belongs_to :segment, foreign_key: true, type: :uuid
      t.integer :attempt_number
      t.integer :duration_milliseconds

      t.timestamps
    end
  end
end
