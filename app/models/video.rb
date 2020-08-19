class Video < ApplicationRecord
  TWITCH = 'twitch'.freeze
  YOUTUBE = 'youtube'.freeze

  belongs_to :run

  validates_with VideoValidator

  def twitch?
    url ? URI.parse(url).host.match?(/^(?:www\.)?(?:twitch\.tv)$/i) : false
  end

  def youtube?
    url ? /^(?:https?:\/\/)?(?:www\.)?youtu(?:be\.com|\.be)\/.+/i.match?(url) : false
  end

  def provider
    if twitch?
      TWITCH
    elsif youtube?
      YOUTUBE
    else
      nil
    end
  end

  def supports_embedding?
    [TWITCH, YOUTUBE].include?(provider)
  end

  def video_id
    return nil unless url
    if youtube?
      # https://www.youtube.com/watch?v=asdf1234&feature=related
      # http://www.youtube.com/embed/watch?feature=player_embedded&v=asdf1234
      # https://youtu.be/asdf1234

      clip_id = /\/watch.*?v=(.+?)(?:&|\z)/i.match(url)
      return clip_id[1] if clip_id
      clip_id = /.+\/([^\/]+$)/.match(url)
      clip_id ? clip_id[1] : nil
    elsif twitch?
      # https://www.twitch.tv/vclip_ideos/12345678

      clip_id = /.+\/([^\/]+$)/.match(url)
      clip_id ? clip_id[1] : nil
    end
  end

  def start_offset_seconds
    ((start_offset_ms || 0) / 1_000.0).to_i
  end

  def start_offset_seconds=(value)
    self.start_offset_ms = (Float(value.presence || 0) * 1_000).round
  end
end
