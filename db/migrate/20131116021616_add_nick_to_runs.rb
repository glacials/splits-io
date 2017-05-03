class AddNickToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :nick, :string
  end
end
