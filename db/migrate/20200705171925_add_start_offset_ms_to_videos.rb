class AddStartOffsetMsToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :start_offset_ms, :integer
    change_column_default :videos, :start_offset_ms, from: nil, to: 10_000
  end
end
