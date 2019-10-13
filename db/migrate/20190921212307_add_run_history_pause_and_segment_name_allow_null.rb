class AddRunHistoryPauseAndSegmentNameAllowNull < ActiveRecord::Migration[6.0]
  def change
    add_column :run_histories, :pause_duration_ms, :bigint
    change_column_null :segments, :name, true
  end
end
