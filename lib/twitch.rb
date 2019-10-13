require 'net/http'

class Twitch
  class Error < StandardError; end
  class NotFound < Error; end

  module User
    def self.login_from_url(twitch_url)
      %r{^https?://(?:www\.)?twitch\.tv/([^/]+)(?:.*)$}.match(twitch_url)[1].downcase
    end

    class << self
      def get(id, token: nil)
        User.route(id).get(Twitch.headers(token: token))['data']
      end

      def route(id)
        Twitch.route["/users?id=#{id}"]
      end
    end
  end

  module Follows
    def self.followed_ids(id, token: nil)
      cursor = nil
      ids = []
      loop do
        response = get(id, token: token, cursor: cursor)
        break if response.code != 200
        body = JSON.parse(response.body)
        break if body['data'].empty?

        cursor = body['pagination']['cursor']
        body['data'].each do |follow|
          ids << follow['to_id']
        end
      end
      ids
    end

    class << self
      def get(id, token: nil, cursor: nil)
        Follows.route(id, cursor: cursor).get(Twitch.headers(token: token))
      end

      def route(id, cursor: nil)
        Twitch.route["/users/follows?#{{
          from_id: id,
          first: 100,
          after: cursor
      }.to_query}"]
      end
    end
  end

  module Videos
    # recent returns videos for the given Twitch user ID from most to least recent. type can be :all, :upload, :archive,
    # or :highlight.
    def self.recent(id, type: :all, token: nil)
      # To the caller this feels as if we're returning an array of all Twitch videos, but it's just an enumerator that
      # lazily fetches more videos only if the caller tries to look at them.
      cursor = nil

      Enumerator.new do |yielder|
        loop do
          response = Videos.get(id, type, token: token, cursor: cursor)
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

    def self.get(id, type, token: nil, cursor: nil)
      Videos.route(id, type, cursor: cursor).get(Twitch.headers(token: token))
    end

    def self.route(id, type, cursor: nil)
      return Twitch.route["/videos?#{{
        user_id: id,
        type: type,
        first: 100,
        after: cursor
      }.to_query}"]
    end
  end

  class << self
    def route
      RestClient::Resource.new('https://api.twitch.tv/helix')
    end

    # headers returns the HTTP headers we should send with the Twitch API request. It accepts a bearer token; if this
    # request is on behalf of a user, you should pass one to improve rate limits (from 30/min to 800/user/min).
    #
    # See: https://dev.twitch.tv/docs/api/guide/#rate-limits
    def headers(token: nil)
      if token.present?
        {'Authorization' => "Bearer #{token}"}
      else
        {'Client-ID' => ENV['TWITCH_CLIENT_ID']}
      end
    end

    # new_tokens! takes a user's current refresh token and returns a hash containing a fresh access token and refresh
    # token e.g.
    #
    # {access_token: 'boop', refresh_token: 'beep'}
    #
    # Upon calling this method you should assume the old access token and refresh token are invalidated by Twitch.
    # See https://dev.twitch.tv/docs/authentication/#refreshing-access-tokens.
    def new_tokens!(refresh_token)
      body = JSON.parse(RestClient::Resource.new('https://id.twitch.tv/oauth2')["/token?#{{
        grant_type: 'refresh_token',
        refresh_token: refresh_token,
        client_id: ENV['TWITCH_CLIENT_ID'],
        client_secret: ENV['TWITCH_CLIENT_SECRET']
      }.to_query}"].post(nil))

      {access_token: body['access_token'], refresh_token: body['refresh_token']}
    end
  end
end
