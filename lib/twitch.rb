require 'net/http'

class Twitch
  module User
    def self.find_by_oauth_token(oauth_token)
      HTTParty.get(uri(oauth_token: oauth_token)).parsed_response
    end

    private

    def self.uri(query)
      URI.parse('https://api.twitch.tv/kraken/user').tap do |uri|
        uri.query = query.to_query
      end
    end
  end
end
