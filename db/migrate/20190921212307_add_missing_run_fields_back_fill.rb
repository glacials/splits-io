class AddMissingRunFieldsBackFill < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def up
    # --- Pause duration on RunHistory ---
    add_column :run_histories, :pause_duration_ms, :bigint
    RunHistory.unscoped.in_batches do |relation|
      relation.update_all pause_duration_ms: 0
      sleep(0.1) # throttle
    end
    # --- Pause duration on RunHistory ---
  end

  def down
    remove_column :run_histories, :pause_duration_ms
  end
end
