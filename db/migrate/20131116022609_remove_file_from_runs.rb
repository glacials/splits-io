class RemoveFileFromRuns < ActiveRecord::Migration
  def change
    remove_column :runs, :file, :string
  end
end
