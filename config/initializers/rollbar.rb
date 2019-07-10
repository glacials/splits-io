require 'rollbar'
Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
  config.environment = ENV['ROLLBAR_ENV']

  config.enabled = (Rails.env == 'production')
  config.js_enabled = false # Somehow adds a '<' to the top of every page when on ¯\_(ツ)_/¯
  config.js_options = {
    accessToken: 'adf345795baf4fc8824abf30aab4bde2',
    captureUncaught: true,
    payload: {
      environment: 'production'
    }
  }

  config.person_method = 'current_user'
  config.person_id_method = 'id'
  config.person_username_method = 'name'
  config.exception_level_filters.merge!('ActionController::RoutingError' => 'ignore')
end
