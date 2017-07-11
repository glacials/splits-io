class DeleteVisitedFromRuns < ActiveRecord::Migration[5.0]
  def change
    remove_column :runs, :visited
  end
end
