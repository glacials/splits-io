class DeleteIgnoreHistoryFromRuns < ActiveRecord::Migration
  def change
    remove_column :runs, :ignore_history
  end
end
