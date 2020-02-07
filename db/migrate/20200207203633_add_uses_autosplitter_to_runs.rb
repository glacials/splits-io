class AddUsesAutosplitterToRuns < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :uses_autosplitter, :bool, null: true
  end
end
