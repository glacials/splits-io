class Api::V4::ApplicationController < ActionController::Base
  include Rails::Pagination

  before_action :read_only_mode, if: -> { ENV["READ_ONLY_MODE"] == "1" }

  rescue_from ActionController::ParameterMissing do |e|
    render status: :bad_request, json: { status: 400, message: e.message }
  end

  def options
    headers["Allow"] = "POST, PUT, DELETE, GET, OPTIONS"
  end

  def read_only_mode
    write_actions = %w[create edit destroy].freeze
    write_methods = %w[POST PUT DELETE PATCH].freeze
    return unless write_actions.include?(action_name) || write_methods.include?(request.method)

    render template: "pages/read_only_mode"
  end

  protected

  # override authie's current_user methods for API, so we don't set or obey cookies
  attr_accessor :current_user

  def build_link_headers(links)
    links.map do |link|
      "<#{link[:url]}>; rel=\"#{link[:rel]}\""
    end.join(", ")
  end

  def not_found(collection, message: nil)
    {
      status: :not_found,
      json: {
        status: 404,
        error: message ||
               "No #{collection} with ID #{params[collection] || params["#{collection}_id"] || params[:id]} found.",
      },
    }
  end

  # Add response body to unauthorized requests
  def doorkeeper_unauthorized_render_options(*)
    {
      json: {
        status: 401,
        error: "Not authorized",
      },
    }
  end

  def set_category
    @category = Category.find(params[:category])
  rescue ActiveRecord::RecordNotFound
    render not_found(:category)
  end

  def set_game
    @game = Game.joins(:srdc).find_by!(speedrun_dot_com_games: { shortname: params[:game] })
  rescue ActiveRecord::RecordNotFound
    render not_found(:game)
  end

  def set_runner
    @runner = User.with_runs.find_by!(name: params[:runner])
  rescue ActiveRecord::RecordNotFound
    render not_found(:runner)
  end

  def set_run
    @run = if params[:historic] == "1"
        Run.includes(:user, :histories, :video, category: [:srdc], game: [:srdc], segments: [:histories]).find36(params[:run])
      else
        Run.includes(:user, :segments, :video, category: [:srdc], game: [:srdc]).find36(params[:run])
      end
  rescue ActiveRecord::RecordNotFound
    render not_found(:run)
  end

  def verify_ownership!
    if params[:claim_token].blank?
      head 401
    elsif params[:claim_token] != @run.claim_token
      head 403
    end
  end

  def set_user
    return unless request.headers["Authorization"].present? || params[:access_token].present?

    # TODO: Is this incorrectly causing all authenticated requests to require the manage_race scope?
    doorkeeper_authorize!(:manage_race)
    self.current_user = User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  rescue ActiveRecord::RecordNotFound
    render status: :unauthorized, json: {
      status: 401,
      error: "No user found for this token",
    }
  end

  def validate_user
    return unless current_user.nil?

    render status: :unauthorized, json: {
      status: 401,
      error: "A user is required for this action",
    }
  end

  def set_race(param: :race_id) # rubocop:disable Naming/AccessorMethodName
    @race = Race.includes(category: [:srdc], entries: [:creator], game: [:srdc]).find(params[param])
    return unless @race.secret_visibility? && !@race.joinable?(user: current_user, token: params[:join_token])

    render status: :forbidden, json: {
      status: 403,
      error: "Must be invited to see this race",
    }
  rescue ActiveRecord::RecordNotFound
    render not_found(:race)
  end
end
