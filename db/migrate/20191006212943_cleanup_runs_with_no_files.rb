class CleanupRunsWithNoFiles < ActiveRecord::Migration[6.0]
  def up
    Run.find_each do |run|
      file = $s3_bucket_internal.object("splits/#{run.s3_filename}")
      next if file.exists?

      run.destroy
    end
  end
end
