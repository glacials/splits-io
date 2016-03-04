class HealthController < ApplicationController
  force_ssl except: [:index]

  def index
    head 200
  end
end
