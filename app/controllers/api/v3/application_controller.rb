class Api::V3::ApplicationController < ActionController::Base
  prepend_before_action :set_cors_headers

  private

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  private

  def ssl_configured?
    Rails.application.config.use_ssl
  end
end
