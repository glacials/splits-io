require 'active_support/concern'

module AvatarSource
  extend ActiveSupport::Concern

  included do
    def avatar
      URI.parse(self[:avatar]).tap do |uri|
        uri.scheme = 'https'
      end.to_s
    end
  end
end
