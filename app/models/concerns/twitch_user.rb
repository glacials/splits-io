require 'active_support/concern'

module TwitchUser
  extend ActiveSupport::Concern

  included do
    def load_from_twitch(response = nil)
      twitch_user = Twitch::User::find_by_oauth_token(twitch_token)

      raise HTTParty::ResponseError.new(response) unless response.success?

      assign_attributes(
        twitch_id: twitch_user['_id'],
        email: twitch_user['email'],
        name: twitch_user['name'],
        avatar: twitch_user['logo']
      )
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
