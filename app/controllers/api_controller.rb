class ApiController < ApplicationController
  def api_v1_run_url(run)
    super(run.id)
  end

  def api_v1_run_path(run)
    super(run.id)
  end
end
