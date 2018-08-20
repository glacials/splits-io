require 'active_support/concern'

module RunnerUser
  extend ActiveSupport::Concern

  included do
    def s3_bytes_used(since: 100.years.ago)
      runs.pluck(:s3_filename).sum(0) do |s3_filename|
        o = $s3_bucket_internal.object("splits/#{s3_filename}")
        if o.exists? && o.last_modified > since
          o.content_length
        else
          0
        end
      end
    end
  end
end
