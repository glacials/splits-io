class AddRunFileDigestToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :run_file_digest, :string
  end
end
