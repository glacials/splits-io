class RemoveHitsFromRuns < ActiveRecord::Migration[4.2]
  def change
    remove_column :runs, :hits
  end
end
