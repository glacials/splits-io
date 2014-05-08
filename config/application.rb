require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module SplitsIO
  class Application < Rails::Application
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.action_controller.allow_forgery_protection = false
  end
end
