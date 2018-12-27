class AddStartedAtEndedAtToRuns < ActiveRecord::Migration[5.2]
  def change
    add_column :run_histories, :started_at, :datetime, default: nil, null: true
    add_column :run_histories, :ended_at,   :datetime, default: nil, null: true
  end
end
