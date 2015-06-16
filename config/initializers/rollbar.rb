require 'rollbar/rails'
Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']

  config.enabled = (Rails.env == 'production')

  config.person_method = 'current_user'
  config.person_id_method = 'id'
  config.person_username_method = 'name'
  config.exception_level_filters.merge!('ActionController::RoutingError' => 'ignore')
end
