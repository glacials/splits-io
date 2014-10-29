class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :remove_www
  before_action :set_mixpanel
  before_action :set_gon

  def remove_www
    redirect_to(subdomain: nil) if request.subdomain == 'www'
  end

  def after_sign_out_path_for(_resource_or_scope)
    request.referrer
  end

  private

  def set_mixpanel
    @mixpanel = Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN']).delay
  end

  def set_gon
    gon.request = {path: request.path}
  end
end
