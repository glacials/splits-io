require 'net/http'

class Twitch
  class Error < StandardError; end
  class NotFound < Error; end

  module User
    def self.login_from_url(twitch_url)
      %r{^https?://(?:www\.)?twitch\.tv/([^/]+)(?:.*)$}.match(twitch_url)[1].downcase
    end

    class << self
      def get(id)
        route(id).get(Twitch.headers)
      end

      def route(id)
        Twitch.route["/users/#{id}"]
      end
    end
  end

  module Follows
    def self.followed_ids(id)
      Rails.cache.fetch([:twitch, :follows, id]) do
        JSON.parse(
          self.get(id)
        )['follows'].map do |follow|
          follow['channel']['_id']
        end
      end
    end

    class << self
      def get(id)
        route(id).get(Twitch.headers)
      end

      def route(id)
        User.route(id)['/follows/channels?limit=100']
      end
    end
  end

  class << self
    def route
      RestClient::Resource.new('https://api.twitch.tv/kraken')
    end

    def headers
      {
        'Accept' => 'application/vnd.twitchtv.v5+json',
        'Client-ID' => ENV['TWITCH_CLIENT_ID']
      }
    end
  end
end
