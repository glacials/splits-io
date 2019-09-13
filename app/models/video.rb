class Video
  attr_accessor :url

  def initialize(url = nil)
    self.url = url
  end

  def twitch?
    url ? URI.parse(url).host.match?(/^(?:www\.)?(?:twitch\.tv)$/i) : false
  end

  def youtube?
    url ? /^(?:https?:\/\/)?(?:www\.)?youtu(?:be\.com|\.be)\/.+/i.match?(url) : false
  end

  def id
    return nil unless url
    if youtube?
      # https://www.youtube.com/watch?v=asdf1234&feature=related
      # http://www.youtube.com/embed/watch?feature=player_embedded&v=asdf1234
      # https://youtu.be/asdf1234

      id = /\/watch.*?v=(.+?)(?:&|\z)/i.match(url)
      return id[1] if id
      id = /.+\/([^\/]+$)/.match(url)
      id ? id[1] : nil
    elsif twitch?
      # https://www.twitch.tv/videos/12345678

      id = /.+\/([^\/]+$)/.match(url)
      id ? id[1] : nil
    end
  end
end
