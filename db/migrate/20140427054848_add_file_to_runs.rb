class AddFileToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :file, :text
  end
end
