module Videoable
  extend ActiveSupport::Concern

  included do
    has_one :video, as: :videoable, dependent: :destroy

    def video_url
      video.try(:url)
    end

    def twitch?
      URI.parse(url).host.match?(/^(www\.)?twitch\.tv$/)
    end

    def youtube?
      URI.parse(url).host.match?(/^(www\.)?(youtube\.com|youtu\.be)$/)
    end
  end
end
