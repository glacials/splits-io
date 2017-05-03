class AddIgnoreHistoryToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :ignore_history, :bool
  end
end
