class DeleteIgnoreHistoryFromRuns < ActiveRecord::Migration[4.2]
  def change
    remove_column :runs, :ignore_history
  end
end
