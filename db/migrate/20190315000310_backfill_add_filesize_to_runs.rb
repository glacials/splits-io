class BackfillAddFilesizeToRuns < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    Run.in_batches.update_all filesize_bytes: 0
    safety_assured do
      change_column_null :runs, :filesize_bytes, false
    end
  end
end
