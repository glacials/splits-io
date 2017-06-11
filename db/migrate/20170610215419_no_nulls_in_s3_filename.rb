class NoNullsInS3Filename < ActiveRecord::Migration[5.0]
  def change
    change_column_null :runs, :s3_filename, false
  end
end
