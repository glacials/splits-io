class RemoveTypeFromRuns < ActiveRecord::Migration[4.2]
  def change
    remove_column :runs, :type, :string
  end
end
