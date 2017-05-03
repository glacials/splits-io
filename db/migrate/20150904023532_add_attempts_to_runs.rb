class AddAttemptsToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :attempts, :integer
  end
end
