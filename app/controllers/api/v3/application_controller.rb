class Api::V3::ApplicationController < ActionController::Base
  include Rails::Pagination

  skip_before_action :set_browser_id
  skip_before_action :touch_auth_session
  before_action :read_only_mode, if: -> { ENV["READ_ONLY_MODE"] == "1" }
  before_action :track

  def options
    headers["Allow"] = "POST, PUT, DELETE, GET, OPTIONS"
  end

  def read_only_mode
    write_actions = %w[create edit destroy]
    write_methods = %w[POST PUT DELETE PATCH]
    if write_actions.include?(action_name) || write_methods.include?(request.method)
      render template: "pages/read_only_mode"
    end
  end

  def track
    TrackJob.perform_later(
      category: controller_name,
      action: action_name,
    )
  end
end
