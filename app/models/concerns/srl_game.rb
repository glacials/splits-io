require 'active_support/concern'

module SRLGame
  extend ActiveSupport::Concern

  included do
    def srl_uri
      if shortname.present?
        URI::HTTP.build(
          host: "speedrunslive.com",
          path: "/races/game/",
          fragment: "!/#{shortname}"
        ).to_s
      end
    end
  end
end
