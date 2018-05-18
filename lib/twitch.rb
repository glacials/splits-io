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
      cursor = nil
      ids = []
      loop do
        response = JSON.parse(get(id, cursor))
        response['follows'].each do |follow|
          ids << follow['channel']['_id']
        end
        cursor = response['_cursor']
        break if cursor.nil?
      end
      ids
    end

    class << self
      def get(id, cursor)
        route(id, cursor).get(Twitch.headers)
      end

      def route(id, cursor)
        User.route(id)["/follows/channels?limit=100&cursor=#{cursor}"]
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
