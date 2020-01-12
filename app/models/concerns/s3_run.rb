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
      File.delete(filename) if filename.present? && File.exist?(filename)
    end
  end
end
