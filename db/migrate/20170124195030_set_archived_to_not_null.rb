class SetArchivedToNotNull < ActiveRecord::Migration[5.0]
  def change
    Run.where(archived: nil).update_all(archived: false)
    change_column_null :runs, :archived, false
  end
end
