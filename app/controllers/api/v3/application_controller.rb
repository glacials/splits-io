class Api::V3::ApplicationController < ActionController::Base
  prepend_before_action :set_cors_headers
  before_action :force_ssl, if: :ssl_configured?

  def options
    headers['Allow'] = 'POST, PUT, DELETE, GET, OPTIONS'
  end

  private

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def force_ssl
    if !request.ssl?
      render status: 301, json: {status: 301, message: "API v3 hits must be over HTTPS."}
    end
  end

  def ssl_configured?
    Rails.application.config.use_ssl
  end
end
