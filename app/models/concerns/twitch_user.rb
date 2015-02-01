require 'active_support/concern'

module TwitchUser
  extend ActiveSupport::Concern

  include HTTParty
  ssl_version :SSLv3

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
      User.where(twitch_id: Twitch::Follows.find_by_user(self))
    end
  end
end
