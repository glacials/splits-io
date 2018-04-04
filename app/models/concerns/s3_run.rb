require 'active_support/concern'

module S3Run
  extend ActiveSupport::Concern

  included do
    def in_s3?
      file = $s3_bucket_internal.object("splits/#{s3_filename}")
      file.exists?
    rescue Aws::S3::Errors::Forbidden
      false
    end

    def migrate_to_s3
      if in_s3?
        puts 'run in s3, skipping'
        return true
      end

      if run_file.nil?
        puts 'run_file is gone, skipping'
        return false
      end

      object = $s3_bucket_internal.put_object(
        key: "splits/#{id36}",
        body: run_file.file
      )

      raise 'error uploading run to s3' if object.nil? || object.key.nil?

      puts 'run stored in s3 :)'
      true
    end
  end
end
