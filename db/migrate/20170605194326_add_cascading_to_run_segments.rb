class AddCascadingToRunSegments < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :segments, :runs
    add_foreign_key :segments, :runs, on_delete: :cascade

    remove_foreign_key :segment_histories, :segments
    add_foreign_key :segment_histories, :segments, on_delete: :cascade
  end
end
