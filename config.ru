# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

if Rails.env.production?
  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare('splitsio', username) &&
      ActiveSupport::SecurityUtils.secure_compare(
        '9b5111dbda4257457ba2c98f0f43604eab4731b2f84ed29790bd80391523c3e626ca2256e951297501ed7fc38d41ab89badc558f1f558ea86dc6d636eaf77a47',
        Digest::SHA512.hexdigest(password),
      )
  end
end

run Rails.application
