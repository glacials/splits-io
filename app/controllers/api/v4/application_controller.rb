class Api::V4::ApplicationController < ActionController::Base
  prepend_before_action :set_cors_headers
  before_action :force_ssl, if: :ssl_configured?

  private

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def force_ssl
    if !request.ssl?
      render status: 301, json: {status: 301, message: "API hits must be over HTTPS."}
    end
  end

  def ssl_configured?
    Rails.application.config.use_ssl
  end

  def not_found(missing_resource_type, missing_resource_id)
    {status: 404, json: {status: 404, message: "No #{missing_resource_type} with id #{missing_resource_id} found."}}
  end

  def set_user
    @user = User.find_by!(name: params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render not_found(:user, params[:user_id])
  end

  def set_game
    @game = Game.find_by(shortname: params[:game_id]) || Game.find(params[:game_id])
  rescue ActiveRecord::RecordNotFound
    render not_found(:game, params[:game_id])
  end

  def set_category
    @category = (@game.try(:categories) || Category).find(params[:category_id])
  rescue ActiveRecord::RecordNotFound
    render not_found(:category, params[:category_id])
  end

  def set_run
    @run = (@category.try(:runs) || Run).find36(params[:run_id])
  rescue ActiveRecord::RecordNotFound
    render not_found(:run, params[:run_id])
  end
end
