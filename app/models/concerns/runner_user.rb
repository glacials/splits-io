require 'active_support/concern'

module RunnerUser
  extend ActiveSupport::Concern

  included do
    def s3_bytes_used(since: 100.years.ago)
      runs.pluck(:s3_filename).sum(0) do |s3_filename|
        s3_run_object = $s3_bucket_internal.object("splits/#{s3_filename}")
        if s3_run_object.exists? && s3_run_object.last_modified > since
          s3_run_object.content_length
        else
          0
        end
      end
    end
  end
end
