class AddTimeToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :time, :int
  end
end
