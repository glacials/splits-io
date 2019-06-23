class AddRunToEntries < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_reference :entries, :run, index: false, null: true
    add_index :entries, :run_id, algorithm: :concurrently

    # Add null: true to allow segments that haven't been completed yet (in-progress runs). Segment gametime columns and
    # columns in the runs table are already nullable.
    change_column_null :segments, :realtime_start_ms,             null: true
    change_column_null :segments, :realtime_end_ms,               null: true
    change_column_null :segments, :realtime_duration_ms,          null: true
    change_column_null :segments, :realtime_shortest_duration_ms, null: true

    # Just piggybacking this here, gametime versions of these columns have a default: false and realtime ones don't, so
    # just making them consistent.
    change_column_default :segments, :realtime_gold,    from: nil, to: false
    change_column_default :segments, :realtime_reduced, from: nil, to: false
    change_column_default :segments, :realtime_skipped, from: nil, to: false
  end
end
