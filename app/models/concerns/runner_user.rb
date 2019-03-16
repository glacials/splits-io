require 'active_support/concern'

module RunnerUser
  extend ActiveSupport::Concern

  included do
    def s3_bytes_used(since: 100.years.ago)
      runs.where('created_at > ?', since).sum(:filesize_bytes)
    end
  end
end
