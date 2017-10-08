class UseBigintForMs < ActiveRecord::Migration[5.0]
  def change
    change_column(:runs, :realtime_duration_ms,    :bigint)
    change_column(:runs, :gametime_duration_ms,    :bigint)
    change_column(:runs, :realtime_sum_of_best_ms, :bigint)
    change_column(:runs, :gametime_sum_of_best_ms, :bigint)

    change_column(:run_histories, :realtime_duration_ms, :bigint)
    change_column(:run_histories, :gametime_duration_ms, :bigint)

    change_column(:segments, :realtime_start_ms,             :bigint)
    change_column(:segments, :gametime_start_ms,             :bigint)
    change_column(:segments, :realtime_end_ms,               :bigint)
    change_column(:segments, :gametime_end_ms,               :bigint)
    change_column(:segments, :realtime_duration_ms,          :bigint)
    change_column(:segments, :gametime_duration_ms,          :bigint)
    change_column(:segments, :realtime_shortest_duration_ms, :bigint)
    change_column(:segments, :gametime_shortest_duration_ms, :bigint)

    change_column(:segment_histories, :realtime_duration_ms, :bigint)
    change_column(:segment_histories, :gametime_duration_ms, :bigint)
  end
end
