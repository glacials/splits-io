require 'active_support/concern'

module S3Run
  extend ActiveSupport::Concern

  included do
    class RunTooLarge < StandardError; end
    class RunDownloadError < StandardError; end

    def file
      # If a block is passed in, a standard File object will be opened, passed to the block, and then closed
      # If no block is passed, the file will be read into memory from S3 and returned as a string
      file = $s3_bucket_internal.object("splits/#{s3_filename}")

      return nil unless file.exists?

      raise RunTooLarge if file.content_length >= (100 * 1024 * 1024) # 100 MiB

      if block_given?
        filename = "tmp/#{s3_filename}"
        result = file.download_file(filename)
        raise RunDownloadError unless result

        local_file = File.open(filename)
        yield local_file
        local_file.close
      else
        file.get.body.read
      end
    rescue Aws::S3::Errors::AccessDenied, Aws::S3::Errors::Forbidden
      nil
    ensure
      File.delete(filename) if File.exist?(filename)
    end

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
