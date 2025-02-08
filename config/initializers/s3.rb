return if ARGV.include?('assets:precompile')

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

# When users upload runs, they do it directly to S3 using a presigned request we generate. When running Splits.io
# locally in Docker, the hostname for that presigned request (localhost) is different than the one the server uses to
# interact with S3 (s3), so we need one S3 client for each hostname even though they both point to the same bucket.
if ENV['AWS_REGION'] == 'local'
  options.merge!(force_path_style: true)

  options_internal = options.clone.merge!(endpoint: "http://#{ENV['S3_HOST']}:4569")
  options_external = options.clone.merge!(endpoint: "http://localhost:4569")
else
  options_internal = options
  options_external = options
end


$s3_client_internal = Aws::S3::Client.new(options_internal)
$s3_client_external = Aws::S3::Client.new(options_external)

$s3_bucket_internal = Aws::S3::Bucket.new(ENV['S3_BUCKET'], client: $s3_client_internal)
$s3_bucket_external = Aws::S3::Bucket.new(ENV['S3_BUCKET'], client: $s3_client_external)

# This bucket holds some denormalized information from the database.
# This helps us run Retriever (https://github.com/splitsio/retriever)
# to fetch user runs by ID or username after the database goes offline permanently.
#
# Bucket file structure:
# Key: <filename>          -> <file contents>
#
#      <run.id>            -> <run.s3_filename>
#      users/<user.name>   -> <user.runs.pluck(:id).to_json>
#      extensions/<run.id> -> <run.program.file_extension>
$s3_shutdown_prep_bucket = Aws::S3::Bucket.new("splits.io-runid-to-s3filename", client: $s3_client_internal)
