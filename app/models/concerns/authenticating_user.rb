require 'active_support/concern'

module AuthenticatingUser
  extend ActiveSupport::Concern

  included do
    def self.authenticate(name, method, secret)
      raise 'Invalid authentication method' unless method == :twitch

      User.where(name: name, twitch_token: secret)
    end
  end
end
