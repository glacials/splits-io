class Api::V3::ApplicationController < ActionController::Base
  before_action :enforce_ssl

  private

  def enforce_ssl
    if config.use_ssl && !request.ssl?
      redirect_to protocol: :https
    end
  end
end
