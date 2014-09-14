class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :remove_www
  before_action :set_mixpanel

  def remove_www
    redirect_to(subdomain: nil) if request.subdomain == 'www'
  end

  def after_sign_out_path_for(_resource_or_scope)
    request.referrer
  end

  def set_mixpanel
    @mixpanel = Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN'])
  end
end
