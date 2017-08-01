class AddGameTime < ActiveRecord::Migration[5.0]
  def change
    add_column :runs, :gametime_duration_ms,    :integer, null: true
    add_column :runs, :gametime_sum_of_best_ms, :integer, null: true

    rename_column :runs, :time,                     :realtime_duration_s     # deprecated
    rename_column :runs, :duration_milliseconds,    :realtime_duration_ms
    rename_column :runs, :sum_of_best,              :realtime_sum_of_best_s  # deprecated
    rename_column :runs, :sum_of_best_milliseconds, :realtime_sum_of_best_ms

    add_column :segments, :gametime_start_ms,             :integer, null: true
    add_column :segments, :gametime_end_ms,               :integer, null: true
    add_column :segments, :gametime_duration_ms,          :integer, null: true
    add_column :segments, :gametime_shortest_duration_ms, :integer, null: true
    add_column :segments, :gametime_gold,                 :boolean, null: false, default: false
    add_column :segments, :gametime_reduced,              :boolean, null: false, default: false
    add_column :segments, :gametime_skipped,              :boolean, null: false, default: false

    rename_column :segments, :start_milliseconds,             :realtime_start_ms
    rename_column :segments, :end_milliseconds,               :realtime_end_ms
    rename_column :segments, :duration_milliseconds,          :realtime_duration_ms
    rename_column :segments, :shortest_duration_milliseconds, :realtime_shortest_duration_ms
    rename_column :segments, :gold,                           :realtime_gold
    rename_column :segments, :skipped,                        :realtime_skipped
    rename_column :segments, :reduced,                        :realtime_reduced

    add_column :segment_histories, :gametime_duration_ms, :integer, null: true

    rename_column :segment_histories, :duration_milliseconds, :realtime_duration_ms
  end
end
