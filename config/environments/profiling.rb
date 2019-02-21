require_relative 'production'

Rails.application.configure do
  config.public_file_server.enabled = true

  logger           = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = config.log_formatter
  config.logger    = ActiveSupport::TaggedLogging.new(logger)

  config.use_ssl = false
end
