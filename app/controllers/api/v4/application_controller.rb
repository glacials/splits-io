require 'example'

class Api::V4::ApplicationController < ActionController::Base
  include Rails::Pagination

  skip_before_action :set_browser_id
  skip_before_action :touch_auth_session
  before_action :force_ssl, if: -> { Rails.application.config.use_ssl }
  before_action :read_only_mode, if: -> { ENV['READ_ONLY_MODE'] == '1' }

  def options
    headers['Allow'] = 'POST, PUT, DELETE, GET, OPTIONS'
  end

  def read_only_mode
    write_actions = %w[create edit destroy]
    write_methods = %w[POST PUT DELETE PATCH]
    if write_actions.include?(action_name) || write_methods.include?(request.method)
      render template: 'pages/read_only_mode'
    end
  end

  private

  def build_link_headers(links)
    links.map do |link|
      "<#{link[:url]}>; rel=\"#{link[:rel]}\""
    end.join(', ')
  end

  def force_ssl
    return if request.ssl?
    secure_uri = URI.parse(request.original_url)
    secure_uri.scheme = 'https'
    response.set_header('Location', secure_uri.to_s)

    render status: :moved_permanently, json: {
      error: 'The Splits I/O API is only accessible over HTTPS.'
    }
  end

  def not_found(collection_name)
    {
      status: 404,
      json: {
        error: "No #{collection_name} with ID #{params[collection_name]} found."
      }
    }
  end

  def set_category
    @category = Category.find(params[:category])
  rescue ActiveRecord::RecordNotFound
    render not_found(:category)
  end

  def set_game
    @game = Game.joins(:srdc).find_by!(speedrun_dot_com_games: {shortname: params[:game]})
  rescue ActiveRecord::RecordNotFound
    render not_found(:game)
  end

  def set_runner
    @runner = User.with_runs.find_by!(name: params[:runner])
  rescue ActiveRecord::RecordNotFound
    render not_found(:runner)
  end

  def set_run
    if params[:run] == 'example'
      @run = Example::Run.example_run
      return
    end

    @run = if params[:historic] == '1'
             Run.includes(:game, :category, :user, :histories, segments: [:histories]).find36(params[:run])
           else
             Run.includes(:game, :category, :user, :segments).find36(params[:run])
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
end
