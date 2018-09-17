module S3Helper
  def s3_bytes_used(user, since: 100.years.ago)
    number_to_human_size(user.s3_bytes_used)
  rescue Aws::Waiters::Errors::UnexpectedError => e
    Rollbar.warn(e, 'Unable to fetch S3 bytes')
    '???'
  end
end
