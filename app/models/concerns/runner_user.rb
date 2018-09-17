require 'active_support/concern'

module RunnerUser
  extend ActiveSupport::Concern

  included do
    def s3_bytes_used(since: 100.years.ago)
      runs.where('created_at > ?', since).sum(0) do |run|
        begin
          s3_run_object = $s3_bucket_internal.object("splits/#{run.s3_filename}")
          s3_run_object.exists? ? s3_run_object.content_length : 0
        rescue Aws::S3::Errors::Forbidden => e
          Rollbar.warn(e, 'Missing/forbidden S3 file while counting runs', run_id: run.id, s3_filename: run.s3_filename)
          0
        end
      end
    end
  end
end
