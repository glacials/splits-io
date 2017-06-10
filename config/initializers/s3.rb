options = {
  region: ENV['AWS_REGION'],
  credentials: Aws::Credentials.new(
    ENV['AWS_ACCESS_KEY_ID'],
    ENV['AWS_SECRET_KEY']
  ),
  http_continue_timeout: 1,
  http_idle_timeout: 5,
  http_open_timeout: 5,
  http_read_timeout: 10,
  retry_limit: 2
}

if ENV['AWS_REGION'] == 'local'
  options.merge!(endpoint: 'http://localhost:4567', force_path_style: true)
end

$s3_client = Aws::S3::Client.new(options)
$s3_bucket = Aws::S3::Bucket.new(ENV['S3_BUCKET'], client: $s3_client)
