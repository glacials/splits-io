require 'active_support/concern'

module S3Run
  extend ActiveSupport::Concern

  included do
    def s3_filename
      super || id36
    end

    def in_s3?
      file = $s3_bucket.object("splits/#{s3_filename}")
      return file.exists?
    rescue Aws::S3::Errors::Forbidden
      return false
    end

    def migrate_to_s3
      if in_s3?
        puts "run in s3, skipping"
        return true
      end

      if run_file.nil?
        puts "run_file is gone, skipping"
        return false
      end

      object = $s3_bucket.put_object(
        key: "splits/#{id36}",
        body: run_file.file
      )

      if object.nil? || object.key.nil?
        raise "error uploading run to s3"
      end

      puts "run stored in s3 :)"
      return true
    end
  end
end
