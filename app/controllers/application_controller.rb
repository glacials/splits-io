class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?

  before_action :remove_www
  before_action :set_gon
  before_action :sanitize_pagination_params

  def remove_www
    redirect_to(subdomain: nil) if request.subdomain == 'www'
  end

  def after_sign_out_path_for(_resource_or_scope)
    request.referrer
  end

  def api_v2_run_url(run)
    super(run.id)
  end

  def api_v2_run_path(run)
    super(run.id)
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
    gon.user = current_user
  end

  def ssl_configured?
    Rails.application.config.use_ssl
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
