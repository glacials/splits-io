require 'net/http'

class Twitch
  module User
    def self.find_by_oauth_token(oauth_token)
      JSON.parse(
        Twitch.kraken["/user?oauth_token=#{oauth_token}"].get
      )
    end

    module OauthToken
      def self.find_by_authorization_code(authorization_code, redirect_uri)
        JSON.parse(
          Twitch.kraken['/oauth2/token'].post(
            {
              client_id: ENV['TWITCH_CLIENT_ID'],
              client_secret: ENV['TWITCH_CLIENT_SECRET'],
              grant_type: 'authorization_code',
              redirect_uri: redirect_uri,
              code: authorization_code
            },
            accept: :json
          )
        )['access_token']
      end
    end

    private

    def self.find(name)
      Twitch.kraken["/users/#{name}"]
    end
  end

  module Follows
    def self.find_by_user(user)
      Rails.cache.fetch([:twitch, :follows, user]) do
        JSON.parse(
          Twitch::User.find(user.name)["/follows/channels?oauth_token=#{user.twitch_token}&limit=500"].get
        )['follows'].map do |follow|
          follow['channel']['_id']
        end
      end
    end
  end

  private

  def self.kraken
    RestClient::Resource.new('https://api.twitch.tv/kraken')
  end
end
