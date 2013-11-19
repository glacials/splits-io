class AddHitsToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :hits, :integer
  end
end
