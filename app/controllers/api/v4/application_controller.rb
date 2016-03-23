class Api::V4::ApplicationController < ActionController::Base
  prepend_before_action :set_cors_headers
  before_action :force_ssl, if: -> { Rails.application.config.use_ssl }

  private

  def set_cors_headers
    headers.merge!(
      'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Methods' => 'POST, PUT, DELETE, GET, OPTIONS',
      'Access-Control-Request-Method' => '*',
      'Access-Control-Allow-Headers' => 'origin, X-Requested-With, Content-Type, Accept, Authorization'
    )
  end

  def build_link_headers(links)
    links.map do |link|
      "<#{link[:url]}>; rel=\"#{link[:rel]}\""
    end.join(', ')
  end

  def force_ssl
    if !request.ssl?
      render status: 301, json: {error: "The Splits I/O API is only accessible over HTTPS."}
    end
  end

  def not_found(collection_name, resource_id)
    {
      status: 404,
      json: {
        error: "No #{collection_name} with ID #{resource_id} found."
      }
    }
  end

  def set_category
    @category = Category.find(params[:category_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    render not_found(:category, params[:category_id] || params[:id])
  end

  def set_game
    @game = Game.find_by!(shortname: params[:game_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    render not_found(:game, params[:game_id] || params[:id])
  end

  def set_runner
    @runner = User.with_runs.find(params[:runner_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    render not_found(:runner, params[:runner_id] || params[:id])
  end

  def set_run
    @run = Run.find36(params[:run_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    render not_found(:run, params[:run_id] || params[:id])
  end
end
