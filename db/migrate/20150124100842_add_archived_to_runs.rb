class AddArchivedToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :archived, :boolean
  end
end
