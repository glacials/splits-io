class BackfillAddStartOffsetToVideos < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    Video.find_in_batches do |records|
      Video.where(id: records.map(&:id)).update_all start_offset: 10
    end
  end
end
