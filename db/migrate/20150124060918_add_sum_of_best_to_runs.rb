class AddSumOfBestToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :sum_of_best, :decimal
  end
end
