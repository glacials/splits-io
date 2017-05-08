class AddSumOfBestMillisecondsToRuns < ActiveRecord::Migration[5.0]
  def change
    add_column :runs, :sum_of_best_milliseconds, :integer
  end
end
