require 'rollbar/rails'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitch,        ENV['TWITCH_CLIENT_ID'], ENV['TWITCH_CLIENT_SECRET']
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
    name: 'google'
  }
end
