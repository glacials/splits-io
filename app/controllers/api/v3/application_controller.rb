class Api::V3::ApplicationController < ActionController::Base
  include Rails::Pagination

  skip_before_action :set_browser_id
  skip_before_action :touch_auth_session
  prepend_before_action :set_cors_headers
  before_action :force_ssl, if: :ssl_configured?
  before_action :read_only_mode, if: -> { ENV['READ_ONLY_MODE'] == '1' }

  def options
    headers['Allow'] = 'POST, PUT, DELETE, GET, OPTIONS'
  end

  def read_only_mode
    write_actions = ['create', 'edit', 'destroy']
    write_methods = ['POST', 'PUT', 'DELETE', 'PATCH']
    if write_actions.include?(action_name) || write_methods.include?(request.method)
      render template: 'pages/read_only_mode'
      return false
    end
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
