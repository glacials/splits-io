class AddArchivedToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :archived, :boolean
  end
end
