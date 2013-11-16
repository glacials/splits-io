class AddNickToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :nick, :string
  end
end
