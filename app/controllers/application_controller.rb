class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?

  before_action :remove_www
  before_action :set_gon

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

  def unauthorized
    raise ActionController::RoutingError.new('Unauthorized')
  end

  private

  def set_gon
    gon.request = {path: request.path}
    gon.user = current_user if user_signed_in?
  end

  def ssl_configured?
    Rails.application.config.use_ssl
  end
end
