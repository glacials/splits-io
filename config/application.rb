require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module SplitsIO
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')

    config.action_controller.allow_forgery_protection = false
    config.active_job.queue_adapter = :delayed_job

    config.assets.precompile += ['darkmode.css']

    ActiveSupport.halt_callback_chains_on_return_false = false
  end
end

WillPaginate.per_page = 20
