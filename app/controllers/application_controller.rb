class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  use_vanity :current_user

  before_action :enforce_ssl
  before_action :remove_www
  before_action :set_gon

  def remove_www
    redirect_to(subdomain: nil) if request.subdomain == 'www'
  end

  def after_sign_out_path_for(_resource_or_scope)
    request.referrer
  end

  def api_v1_run_url(run)
    super(run.id)
  end

  def api_v1_run_path(run)
    super(run.id)
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

  private

  def set_gon
    gon.request = {path: request.path}
    gon.user = current_user if user_signed_in?
  end

  def enforce_ssl
    if config.use_ssl && !request.ssl?
      redirect_to protocol: :https
    end
  end
end
