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
        route(id).get(Twitch.headers)['data']
      end

      def route(id)
        Twitch.route["/users?id=#{id}"]
      end
    end
  end

  module Follows
    def self.followed_ids(id)
      cursor = nil
      ids = []
      loop do
        response = JSON.parse(get(id, cursor))
        response['data'].each do |follow|
          ids << follow['to_id']
        end
        cursor = response['pagination']['cursor']
        break if cursor.nil?
      end
      ids
    end

    class << self
      def get(id, cursor)
        route(id, cursor).get(Twitch.headers)
      end

      def route(id, cursor)
        Twitch.route["/users/follows?from_id=#{id}&after=#{cursor}"]
      end
    end
  end

  module Videos
    # recent returns recent videos on the channel of the given Twitch user ID. type can be :all, :upload, :archive, or
    # :highlight.
    def self.recent(id, type: :all)
      cursor = nil
      Enumerator.new do |yielder|
        loop do
          response = get(id, type, cursor: cursor)
          raise StopIteration if response.code != 200
          body = JSON.parse(response.body)
          raise StopIteration if body['data'].empty?

          cursor = body['pagination']['cursor']
          body['data'].each do |video|
            yielder << video
          end
        end
      end.lazy
    end

    class << self
      def get(id, type, cursor: nil)
        route(id, type, cursor).get(Twitch.headers)
      end

      def route(id, type, cursor)
        return Twitch.route["/videos?#{{
          user_id: id,
          type: type,
          after: cursor
        }.to_query}"]
      end
    end
  end

  class << self
    def route
      RestClient::Resource.new('https://api.twitch.tv/helix')
    end

    def headers
      {'Client-ID' => ENV['TWITCH_CLIENT_ID']}
    end
  end
end
