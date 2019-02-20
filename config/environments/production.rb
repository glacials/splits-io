Rails.application.configure do
  # Code is not reloaded between requests.
  config.cache_classes = true
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false

  # Attempt to read encrypted secrets from `config/secrets.yml.enc`.
  # Requires an encryption key in `ENV["RAILS_MASTER_KEY"]` or
  # `config/secrets.yml.key`.
  config.read_encrypted_secrets = true

  config.action_controller.perform_caching = true
  config.cache_store = :dalli_store,
    (ENV['MEMCACHED_SERVERS'] || '').split(','),
    {
      username: ENV['MEMCACHED_USERNAME'],
      password: ENV['MEMCACHED_PASSWORD'],
      failover: true,
      socket_timeout: 1.5,
      socket_failure_delay: 0.2
    }

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local


  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Set to :debug to see everything in the log.
  config.log_level = :warn

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = "http://assets.example.com"

  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Disable automatic flushing of the log to improve performance.
  # config.autoflush_log = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.use_ssl = ENV.fetch('USE_SSL', '1') == '1'
  config.read_only = false
  config.action_cable.allowed_request_origins = ['https://splits.io', 'https://*.splits.io']
end
