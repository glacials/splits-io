class AddNameToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :name, :string
  end
end
