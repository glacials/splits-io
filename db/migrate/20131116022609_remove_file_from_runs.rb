class RemoveFileFromRuns < ActiveRecord::Migration[4.2]
  def change
    remove_column :runs, :file, :string
  end
end
