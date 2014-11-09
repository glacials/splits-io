class RemoveHitsFromRuns < ActiveRecord::Migration
  def change
    remove_column :runs, :hits
  end
end
