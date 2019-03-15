class BackfillAddFilesizeToRuns < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    Run.in_batches.update_all filesize: 0
    change_column_null :runs, :filesize, false
  end
end
