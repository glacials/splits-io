class AddS3FilenameToRuns < ActiveRecord::Migration[5.0]
  def change
    add_column :runs, :s3_filename, :string
  end
end
