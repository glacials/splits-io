class AddFilesizeToRuns < ActiveRecord::Migration[5.2]
  def up
    add_column :runs, :filesize, :bigint
    change_column_default :runs, :filesize, 0
  end

  def down
    remove_column :runs, :filesize
  end
end
