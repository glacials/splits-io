require 'rollbar/rails'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitch, ENV['TWITCH_CLIENT_ID'], ENV['TWITCH_CLIENT_SECRET']
end
