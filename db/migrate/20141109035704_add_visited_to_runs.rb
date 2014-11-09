class AddVisitedToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :visited, :boolean, null: false, default: false
  end
end
