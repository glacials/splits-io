class AddStartOffsetToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :start_offset, :integer
    change_column_default :videos, :start_offset, 10
  end
end
