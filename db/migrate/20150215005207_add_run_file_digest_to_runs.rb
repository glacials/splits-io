class AddRunFileDigestToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :run_file_digest, :string
  end
end
