require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SplitsIO
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.autoload_paths << Rails.root.join("lib")
    config.eager_load_paths << Rails.root.join("lib")

    config.action_controller.allow_forgery_protection = false
    config.active_job.queue_adapter = :delayed_job

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    config.to_prepare do
      Doorkeeper::AuthorizationsController.layout "application"
    end

    config.action_cable.disable_request_forgery_protection = true
    config.action_cable.url = "/api/cable"
    config.action_cable.mount_path = "/api/cable"

    config.active_storage.variant_processor = :vips

    config.load_defaults 6.1
    # TODO: Bump below (NOT above) to 7.0 after 6.1 is fully deployed to all boxes in prod once.
    config.active_support.cache_format_version = 6.1

    config.active_storage.variant_processor = :vips
  end
end
