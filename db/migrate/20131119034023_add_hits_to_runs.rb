class AddHitsToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :hits, :integer
  end
end
