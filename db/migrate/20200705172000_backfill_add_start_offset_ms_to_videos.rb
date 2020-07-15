class BackfillAddStartOffsetMsToVideos < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    Video.where(start_offset_ms: nil).in_batches do |records|
      records.update_all start_offset_ms: 10_000
      sleep(0.01)
    end
    safety_assured do
      change_column_null :videos, :start_offset_ms, false
    end
  end
end
