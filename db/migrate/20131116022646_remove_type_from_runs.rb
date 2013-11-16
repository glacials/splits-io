class RemoveTypeFromRuns < ActiveRecord::Migration
  def change
    remove_column :runs, :type, :string
  end
end
