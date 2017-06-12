class DropRunFiles < ActiveRecord::Migration[5.0]
  def change
    remove_column :runs, :run_file_digest
    drop_table :run_files
  end
end
