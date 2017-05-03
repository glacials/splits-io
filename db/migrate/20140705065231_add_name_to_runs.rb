class AddNameToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :name, :string
  end
end
