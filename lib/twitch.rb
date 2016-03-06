require 'net/http'

class Twitch
  class Error < StandardError; end
  class NotFound < Error; end

  module User
    def self.login_from_url(twitch_url)
      /^https?:\/\/(?:www\.)?twitch\.tv\/([^\/]+)(?:.*)$/.match(twitch_url)[1]
    end

    private

    def self.get(login)
      route(login).get
    end

    def self.route(login)
      Twitch.route["/users/#{login}"]
    end
  end

  module Follows
    def self.followed_ids(login)
      Rails.cache.fetch([:twitch, :follows, login]) do
        JSON.parse(
          Twitch::Follows.get(login)
        )['follows'].map do |follow|
          follow['channel']['_id']
        end
      end
    end

    private

    def self.get(login)
      route(login).get
    end

    def self.route(login)
      Twitch::User.route(login)["/follows/channels?limit=500"]
    end
  end

  private

  def self.route
    RestClient::Resource.new('https://api.twitch.tv/kraken')
  end
end
