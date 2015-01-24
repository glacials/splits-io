class AddSumOfBestToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :sum_of_best, :decimal
  end
end
