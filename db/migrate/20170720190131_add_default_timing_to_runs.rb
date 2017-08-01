class AddDefaultTimingToRuns < ActiveRecord::Migration[5.0]
  def change
    add_column :runs, :default_timing, :string, null: false, default: 'real'
  end
end
