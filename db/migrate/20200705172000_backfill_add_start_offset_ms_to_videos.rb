class BackfillAddStartOffsetMsToVideos < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    Video.find_in_batches do |records|
      Video.where(id: records.map(&:id)).update_all start_offset_ms: 10_000
    end
    safety_assured do
      change_column_null :videos, :start_offset_ms, false
    end
  end
end
