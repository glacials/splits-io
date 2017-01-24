class SetArchivedDefaultToFalse < ActiveRecord::Migration[5.0]
  def change
    change_column_default :runs, :archived, false
  end
end
