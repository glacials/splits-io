class PatreonUsersController < ApplicationController
  def out
    redirect_to("https://www.patreon.com/oauth2/authorize?response_type=code&client_id=#{ENV['PATREON_CLIENT_ID']}&redirect_uri=#{redirect_uri}")
  end

  def in
    oauth_client = Patreon::OAuth.new(ENV['PATREON_CLIENT_ID'], ENV['PATREON_CLIENT_SECRET'])

    tokens = oauth_client.get_tokens(params[:code], redirect_uri)
    access_token = tokens['access_token']
    refresh_token = tokens['refresh_token']

    creator_id = '2972755' # it me

    api_client = Patreon::API.new(access_token)
    user_response = api_client.fetch_user

    user = user_response['data']
    if user.nil?
      redirect_to settings_path, alert: 'There was an issue connecting your Patreon account. Please try again.'
      return
    end

    included = user_response['included']
    pledge_cents = 0
    pledge_created_at = nil

    if included
      pledge = included.find do |obj|
        obj['type'] == 'pledge' && obj['relationships']['creator']['data']['id'] == creator_id
      end

      pledge_cents = pledge['attributes']['amount_cents']
      pledge_created_at = pledge['attributes']['created_at']
    end

    PatreonUser.find_or_initialize_by(user: current_user).update(
      access_token:  access_token,
      refresh_token: refresh_token,

      patreon_id: user['id'],
      full_name:  user['attributes']['full_name'],

      pledge_cents:      pledge_cents,
      pledge_created_at: pledge_created_at
    )

    redirect_to(
      settings_path,
      notice: "You're now linked with Patreon! If you're a patron, your benefits have been activated :)"
    )
  end

  def unlink
    current_user.patreon.destroy

    redirect_to settings_path, notice: 'Patreon account unlinked :)'
  end

  private

  def redirect_uri
    "#{request.protocol}#{request.host_with_port}/auth/patreon/callback"
  end
end
