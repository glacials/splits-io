class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :remove_www
  before_action :set_gon
  before_action :sanitize_pagination_params
  before_action :read_only_mode, if: -> { ENV['READ_ONLY_MODE'] == '1' }
  before_action :authorize_rmp

  rescue_from Authie::Session::ValidityError, with: :auth_session_error
  rescue_from Authie::Session::InactiveSession, with: :auth_session_error
  rescue_from Authie::Session::ExpiredSession, with: :auth_session_error
  rescue_from Authie::Session::BrowserMismatch, with: :auth_session_error
  rescue_from Authie::Session::HostMismatch, with: :auth_session_error

  def read_only_mode
    write_actions = %w[create edit destroy]
    write_methods = %w[POST PUT DELETE PATCH]
    if write_actions.include?(action_name) || write_methods.include?(request.method)
      render template: 'pages/read_only_mode'
      return false
    end
  end

  def remove_www
    redirect_to(subdomain: nil) if request.subdomain == 'www'
  end

  def after_sign_out_path_for(_resource_or_scope)
    request.referer
  end

  def not_found
    raise ActionController::RoutingError, 'Not found'
  end

  def bad_request
    raise ActionController::BadRequest, 'Bad request'
  end

  def unauthorized
    raise ActionController::RoutingError, 'Unauthorized'
  end

  private

  def set_gon
    gon.request = {path: request.path}

    gon.user = if current_user.nil?
                 nil
               else
                 {id: current_user.id.to_s, name: current_user.name}
               end
  end

  def sanitize_pagination_params
    if params[:page].blank?
      params[:page] = 1
      return
    end

    params[:page] = params[:page].to_i
    bad_request if params[:page] < 1
  end

  def auth_session_error
    flash.now[:alert] = 'Your session is no longer valid, please sign in again.'
  end

  def authorize_rmp
    Rack::MiniProfiler.authorize_request if current_user.try(:admin?)
  end
end
