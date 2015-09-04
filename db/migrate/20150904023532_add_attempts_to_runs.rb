class AddAttemptsToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :attempts, :integer
  end
end
