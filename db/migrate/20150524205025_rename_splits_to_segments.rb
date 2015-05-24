class RenameSplitsToSegments < ActiveRecord::Migration
  def change
    rename_table :splits, :segments
  end
end
