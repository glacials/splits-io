class IncreaseDbMsLimit < ActiveRecord::Migration[5.0]
  def change
    change_column :runs, :duration_milliseconds, :integer, limit: 8
    change_column :runs, :sum_of_best_milliseconds, :integer, limit: 8

    change_column :segments, :duration_milliseconds, :integer, limit: 8
    change_column :segments, :start_milliseconds, :integer, limit: 8
    change_column :segments, :end_milliseconds, :integer, limit: 8
    change_column :segments, :shortest_duration_milliseconds, :integer, limit: 8

    change_column :segment_histories, :duration_milliseconds, :integer, limit: 8
  end
end
