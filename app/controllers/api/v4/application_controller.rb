class Api::V4::ApplicationController < ActionController::Base
  prepend_before_action :set_cors_headers
  before_action :force_ssl, if: -> { Rails.application.config.use_ssl }

  def options
    headers['Allow'] = 'POST, PUT, DELETE, GET, OPTIONS'
  end

  private

  def set_cors_headers
    headers.merge!(
      'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Methods' => '*',
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
    @category = Category.find(params[:category])
  rescue ActiveRecord::RecordNotFound
    render not_found(:category, params[:category])
  end

  def set_game
    @game = Game.find_by!(shortname: params[:game])
  rescue ActiveRecord::RecordNotFound
    render not_found(:game, params[:game])
  end

  def set_runner
    @runner = User.with_runs.find_by!(name: params[:runner])
  rescue ActiveRecord::RecordNotFound
    render not_found(:runner, params[:runner])
  end

  def set_run
    @run = Run.find36(params[:run])
  rescue ActiveRecord::RecordNotFound
    render not_found(:run, params[:run])
  end

  def verify_ownership!
    unless @run.claim_token.present? && params[:claim_token] == @run.claim_token
      head 401
    end
  end
end
