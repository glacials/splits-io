require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module SplitsIO
  class Application < Rails::Application
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.action_controller.allow_forgery_protection = false
    config.cache_store = :redis_store, 'redis://pub-redis-11548.us-east-1-2.5.ec2.garantiadata.com:11548/o/cache', {
      expires_in: 90.minutes
    }
  end
end

WillPaginate.per_page = 20
