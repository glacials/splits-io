class PatreonUsersController < ApplicationController
  def out
    redirect_to(URI::HTTPS.build(
      host: 'www.patreon.com',
      path: '/oauth2/authorize',
      query: {
        response_type: 'code',
        client_id: ENV['PATREON_CLIENT_ID'],
        redirect_uri: redirect_uri
      }.to_query
    ).to_s)
  end

  def in
    tokens = patreon_oauth_client.get_tokens(params[:code], redirect_uri)
    res = update_patreon_user(
      user: current_user,
      access_token: tokens['access_token'],
      refresh_token: tokens['refresh_token']
    )

    redirect_to(settings_path, res.present? ? {notice: link_success_msg} : {alert: link_failure_msg})
  end

  def unlink
    current_user.patreon.try(:destroy)
    redirect_to settings_path, notice: 'Patreon account unlinked :)'
  end

  private

  def patreon_oauth_client
    Patreon::OAuth.new(ENV['PATREON_CLIENT_ID'], ENV['PATREON_CLIENT_SECRET'])
  end

  def patreon_api_client(access_token)
    Patreon::API.new(access_token)
  end

  def redirect_uri
    "#{request.protocol}#{request.host_with_port}/auth/patreon/callback"
  end

  def update_patreon_user(user:, access_token:, refresh_token:)
    user_response = patreon_api_client(access_token).fetch_user
    return nil if user_response['data'].nil?

    PatreonUser.find_or_initialize_by(user: user).update(
      access_token:  access_token,
      refresh_token: refresh_token,

      patreon_id: user_response['data']['id'],
      full_name:  user_response['data']['attributes']['full_name'],

      pledge_cents:      pledge_cents(user_response),
      pledge_created_at: pledge_created_at(user_response)
    )
  end

  def creator_id
    '2972755'
  end

  def pledge_cents(user_response)
    return 0 if user_response['included'].blank?

    user_response['included'].find do |obj|
      obj['type'] == 'pledge' && obj['relationships']['creator']['data']['id'] == creator_id
    end['attributes']['amount_cents']
  end

  def pledge_created_at(user_response)
    return nil if user_response['included'].blank?

    user_response['included'].find do |obj|
      obj['type'] == 'pledge' && obj['relationships']['creator']['data']['id'] == creator_id
    end['attributes']['created_at']
  end

  def link_success_msg
    "You're now linked with Patreon! If you're a patron, your benefits have been activated :)"
  end

  def link_failure_msg
    'There was an issue connecting your Patreon account! Please try again.'
  end
end
