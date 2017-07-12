class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?

  before_action :remove_www
  before_action :set_gon
  before_action :sanitize_pagination_params
  before_action :read_only_mode, if: -> { ENV['READ_ONLY_MODE'] == '1' }

  def read_only_mode
    write_actions = ['create', 'edit', 'destroy']
    write_methods = ['POST', 'PUT', 'DELETE', 'PATCH']
    if write_actions.include?(action_name) || write_methods.include?(request.method)
      render template: 'pages/read_only_mode'
      return false
    end
  end

  def remove_www
    redirect_to(subdomain: nil) if request.subdomain == 'www'
  end

  def after_sign_out_path_for(_resource_or_scope)
    request.referrer
  end

  def not_found
    raise ActionController::RoutingError.new('Not found')
  end

  def bad_request
    raise ActionController::BadRequest.new('Bad request')
  end

  def unauthorized
    raise ActionController::RoutingError.new('Unauthorized')
  end

  private

  def set_gon
    gon.request = {path: request.path}

    if current_user.nil?
      gon.user = nil
    else
      gon.user = {
        id: current_user.id,
        name: current_user.name
      }
    end
  end

  def ssl_configured?
    Rails.application.config.use_ssl && (controller_name != 'health')
  end

  def sanitize_pagination_params
    if params[:page].blank?
      params[:page] = 1
      return
    end

    params[:page] = params[:page].to_i
    if params[:page] < 1
      bad_request
    end
  end
end
