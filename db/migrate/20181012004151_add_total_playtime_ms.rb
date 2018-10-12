class AddTotalPlaytimeMs < ActiveRecord::Migration[5.2]
  def change
    add_column :runs, :total_playtime_ms, :bigint
  end
end
