require 'net/http'

class Twitch
  class Error < StandardError; end
  class NotFound < Error; end

  module User
    def self.login_from_url(twitch_url)
      %r{^https?://(?:www\.)?twitch\.tv/([^/]+)(?:.*)$}.match(twitch_url)[1].downcase
    end

    class << self
      def get(login)
        route(login.downcase).get(Twitch.headers)
      end

      def route(login)
        Twitch.route["/users/#{login}"]
      end
    end
  end

  module Follows
    def self.followed_ids(login)
      Rails.cache.fetch([:twitch, :follows, login]) do
        JSON.parse(
          self.get(login)
        )['follows'].map do |follow|
          follow['channel']['_id']
        end
      end
    end

    class << self
      def get(login)
        route(login).get(Twitch.headers)
      end

      def route(login)
        User.route(login)['/follows/channels?limit=500']
      end
    end
  end

  class << self
    def route
      RestClient::Resource.new('https://api.twitch.tv/kraken')
    end

    def headers
      {
        'Accept' => 'application/vnd.twitchtv.v4+json',
        'Client-ID' => ENV['TWITCH_CLIENT_ID']
      }
    end
  end
end
