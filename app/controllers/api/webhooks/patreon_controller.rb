class Api::Webhooks::PatreonController < ApplicationController
  before_action :set_patreon_user
  before_action :verify_signature

  def create
    case request.headers['X-Patreon-Event']
    when 'pledges:create'
      @patreon_user.update(pledge_cents: pledge_cents, pledge_created_at: pledge_created_at)
    when 'pledges:update'
      @patreon_user.update(pledge_cents: pledge_cents)
    when 'pledges:delete'
      @patreon_user.update(pledge_cents: 0)
    else
      Rollbar.warn("Unknown Patreon webhook #{request.headers['X-Patreon-Event']}")
    end
  end

  private

  def set_patreon_user
    @patreon_user = PatreonUser.find_by(patreon_id: params[:data][:relationships][:patron][:data][:id])
    throw(:abort) if @patreon_user.nil?
  end

  def pledge_cents
    params[:data][:attributes][:amount_cents]
  end

  def pledge_created_at
    params[:data][:attributes][:created_at]
  end

  def verify_signature
    throw(:abort) if request.headers['X-Patreon-Signature'] != digest(request.body.read)
  end

  def digest(data)
    OpenSSL::HMAC.hexdigest('md5', ENV['PATREON_WEBHOOK_SECRET'], data)
  end
end
