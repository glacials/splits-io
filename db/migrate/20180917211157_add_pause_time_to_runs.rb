class AddPauseTimeToRuns < ActiveRecord::Migration[5.2]
  def change
    add_column :runs, :pausetime_duration_ms, :bigint
  end
end
