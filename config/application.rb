require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SplitsIO
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')

    config.action_controller.allow_forgery_protection = false
    config.active_job.queue_adapter = :delayed_job

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    config.to_prepare do
      Doorkeeper::AuthorizationsController.layout 'application'
    end

    config.action_cable.disable_request_forgery_protection = true
    config.action_cable.url = '/api/cable'
    config.action_cable.mount_path = '/api/cable'

    Webpacker::Compiler.env['STRIPE_PUBLISHABLE_KEY'] = ENV['STRIPE_PUBLISHABLE_KEY']

    config.active_storage.variant_processor = :vips
  end
end
