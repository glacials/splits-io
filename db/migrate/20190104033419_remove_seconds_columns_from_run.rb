class RemoveSecondsColumnsFromRun < ActiveRecord::Migration[5.2]
  def change
    remove_column :runs, :realtime_duration_s, :decimal
    remove_column :runs, :realtime_sum_of_best_s, :decimal
  end
end
