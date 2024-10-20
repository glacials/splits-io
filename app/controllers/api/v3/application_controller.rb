class Api::V3::ApplicationController < ActionController::Base
  include Rails::Pagination

  before_action :read_only_mode, if: -> { ENV["READ_ONLY_MODE"] == "1" }

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
end
