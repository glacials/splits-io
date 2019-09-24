require_relative 'production'

Rails.application.configure do
  config.public_file_server.enabled = true

  logger           = ActiveSupport::Logger.new('log/profiling.log')
  logger.formatter = config.log_formatter
  config.logger    = ActiveSupport::TaggedLogging.new(logger)

  config.force_ssl = false
end
