class AddGhostToEntries < ActiveRecord::Migration[6.0]
  def change
    safety_assured { rename_column :entries, :user_id, :runner_id }
    safety_assured { add_column :entries, :ghost, :boolean, null: false, default: false }

    safety_assured { add_reference :entries, :creator, null: true }
    Entry.find_each do |entry|
      entry.update(creator_id: entry.runner_id)
    end
    change_column_null :entries, :creator_id, null: false
  end
end
