class RemoveFileFromRunsAgain < ActiveRecord::Migration[4.2]
  def change
    remove_column :runs, :file
  end
end
