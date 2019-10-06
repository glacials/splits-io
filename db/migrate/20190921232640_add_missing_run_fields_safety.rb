class AddMissingRunFieldsSafety < ActiveRecord::Migration[6.0]
  def change
    change_column_null :run_histories, :pause_duration_ms, false

    change_column_null :segments, :name, true
  end
end
