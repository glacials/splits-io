require 'net/http'

class Twitch
  module User
    def self.find_by_oauth_token(oauth_token)
      HTTParty.get(uri(oauth_token: oauth_token)).parsed_response
    end

    def self.uri(query) URI.parse('https://api.twitch.tv/kraken/user').tap do |uri|
        uri.query = query.to_query
      end
    end
  end

  module Follows
    def self.find_by_user(user)
      Rails.cache.fetch([:twitch, :follows, user]) do
        HTTParty.get(
          URI::parse("https://api.twitch.tv/kraken/users/#{user.name}/follows/channels").tap do |uri|
            uri.query = {oauth_token: user.twitch_token, limit: 500}.to_query
          end.to_s
        )["follows"].map { |follow| follow["channel"]["_id"] }
      end
    end
  end
end
