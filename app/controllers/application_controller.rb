class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :remove_www

  def remove_www
    if request.subdomain == 'www'
      redirect_to subdomain: nil
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end
end
