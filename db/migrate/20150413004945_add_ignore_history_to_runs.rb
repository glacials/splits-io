class AddIgnoreHistoryToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :ignore_history, :bool
  end
end
