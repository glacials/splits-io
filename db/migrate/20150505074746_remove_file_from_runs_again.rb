class RemoveFileFromRunsAgain < ActiveRecord::Migration
  def change
    remove_column :runs, :file
  end
end
