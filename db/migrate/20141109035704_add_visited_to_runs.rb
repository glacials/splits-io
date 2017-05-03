class AddVisitedToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :visited, :boolean, null: false, default: false
  end
end
