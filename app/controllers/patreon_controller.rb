class PatreonController < ApplicationController
  def out
    redirect_to("https://www.patreon.com/oauth2/authorize?response_type=code&client_id=#{ENV['PATREON_CLIENT_ID']}&redirect_uri=#{redirect_uri}")
  end

  def in
    oauth_client = Patreon::OAuth.new(ENV['PATREON_CLIENT_ID'], ENV['PATREON_CLIENT_SECRET'])
    tokens = oauth_client.get_tokens(params[:code], redirect_uri)
    access_token = tokens['access_token']
    refresh_token = tokens['refresh_token']

    creator_id = "2972755" # it me

    api_client = Patreon::API.new(access_token)
    user_response = api_client.fetch_user()
    @user = user_response['data']
    included = user_response['included']
    if included
      @pledge = included.find {|obj| obj['type'] == 'pledge' && obj['relationships']['creator']['data']['id'] == creator_id}
      @campaign = included.find {|obj| obj['type'] == 'campaign' && obj['relationships']['creator']['data']['id'] == creator_id}
    else
      @pledge = nil
      @campaign = nil
    end

    if @user.nil?
      redirect_to settings_path, alert: 'There was an issue connecting your Patreon account. Please try again.'
      return
    end

    pledge_cents = 0
    pledge_created_at = nil

    if @pledge.present?
      pledge_cents = @pledge['attributes']['amount_cents']
      pledge_created_at = @pledge['attributes']['created_at']
    end

    patreon_user = {
      'user_id' => current_user.id.to_s,
      'access_token' => access_token,
      'refresh_token' => refresh_token,

      'patreon_id' => @user['id'],
      'patreon_full_name' => @user['attributes']['full_name'],

      'pledge_cents' => pledge_cents,
      'pledge_created_at' => pledge_created_at,

      'created_at' => Time.now.to_i,
      'updated_at' => Time.now.to_i
    }

    $dynamodb_patreon_users.put_item(item: patreon_user)

    redirect_to(
      settings_path,
      notice: "You're now linked with Patreon! If you're a patron, your benefits have been activated :)"
    )
  end

  def unlink
    $dynamodb_patreon_users.delete_item(
      key: {
        user_id: current_user.id.to_s
      }
    )

    redirect_to settings_path, notice: "Patreon account unlinked :)"
  end
end

def failure
  redirect_to redirect_path, alert: "Error: #{params[:message]}"
end

private

def redirect_path
  cookies.delete(:return_to) || root_path
end

def redirect_uri
  "#{request.protocol}#{request.host_with_port}/auth/patreon/callback"
end
