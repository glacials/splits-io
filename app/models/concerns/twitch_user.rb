require 'active_support/concern'

module TwitchUser
  extend ActiveSupport::Concern

  included do
    def load_from_twitch
      response = HTTParty.get("https://api.twitch.tv/kraken/user?oauth_token=#{twitch_token}")

      self.twitch_id = response["_id"]
      self.email = response["email"]
      self.name = response["name"]
      self.avatar = response["logo"]
    end

    def follows
      User.where(
        twitch_id: HTTParty.get(
          URI::parse("https://api.twitch.tv/kraken/users/#{name}/follows/channels").tap do |uri|
            uri.query = {
              oauth_token: twitch_token,
              limit: 500
            }.to_query
          end.to_s
        )["follows"].map { |follow| follow["channel"]["_id"] }
      ).joins(:runs).group("users.id")
    end
  end
end
