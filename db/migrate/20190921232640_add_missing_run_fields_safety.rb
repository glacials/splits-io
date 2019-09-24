class AddMissingRunFieldsSafety < ActiveRecord::Migration[6.0]
  def change
    # --- Pause duration on RunHistory ---
    change_column_null :run_histories, :pause_duration_ms, false
    # --- Pause duration on RunHistory ---

    # --- Icon on Segment ---
    add_column :segments, :icon, :string
    # --- Icon on Segment ---
  end
end
