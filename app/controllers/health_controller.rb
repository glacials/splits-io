class HealthController < ApplicationController
  force_ssl except: [:index]
  skip_before_action :set_browser_id
  skip_before_action :touch_auth_session

  def index
    head 200
  end
end
