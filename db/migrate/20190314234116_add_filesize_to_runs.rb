class AddFilesizeToRuns < ActiveRecord::Migration[5.2]
  def up
    add_column :runs, :filesize_bytes, :bigint
    change_column_default :runs, :filesize_bytes, 0
  end

  def down
    remove_column :runs, :filesize_bytes
  end
end
