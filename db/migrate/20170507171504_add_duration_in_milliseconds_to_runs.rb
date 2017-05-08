class AddDurationInMillisecondsToRuns < ActiveRecord::Migration[5.0]
  def change
    add_column :runs, :duration_milliseconds, :integer
  end
end
