class RemoveNameFromRuns < ActiveRecord::Migration[5.0]
  def change
    remove_column :runs, :name
  end
end
