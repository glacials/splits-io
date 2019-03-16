class BackfillFilesize < ActiveRecord::Migration[5.2]
  def change
    Run.where(filesize_bytes: 0).in_batches.each_record do |run|
      begin
        s3_run_object = $s3_bucket_internal.object("splits/#{run.s3_filename}")
        if s3_run_object.exists?
          run.update(filesize_bytes: s3_run_object.content_length)
        end
      rescue Aws::S3::Errors::Forbidden => e
      end
    end
  end
end
