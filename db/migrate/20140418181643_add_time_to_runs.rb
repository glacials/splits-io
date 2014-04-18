class AddTimeToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :time, :int
  end
end
