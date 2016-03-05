module SpeedrunDotCom
  class NotFound < StandardError; end
  class ServerError < StandardError; end

  class Run
    attr_accessor :id, :players

    def initialize(attrs)
      self.id = attrs['id']
      self.players = attrs['players']
    end

    def self.id_from_url(url)
      if url.blank?
        return nil
      end

      URI.parse(url).tap do |uri|
        unless uri.host =~ /^(www\.)?(speedrun.com)$/ && uri.path =~ /^\/run\/(.*)$/
          return false
        end

        return /^\/run\/(.*)$/.match(uri.path)[1]
      end
    rescue URI::InvalidURIError
      return false
    end

    def self.url_from_id(id)
      return nil if id.blank?
      "http://www.speedrun.com/run/#{id}"
    end
  end

  class User
    attr_accessor :id, :twitch_login

    def initialize(attrs)
      self.id = attrs['id']
      self.twitch_login = Twitch.login_from_uri(attrs['twitch']['uri'])
    end
  end

  def self.run(id)
    r = raw_run(id)
    Run.new(r)
  end

  def self.user(id)
    u = raw_user(id)
    User.new(u)
  end

  private

  def self.raw_run(id)
    res = HTTParty.get(
      URI.parse("http://speedrun.com/api/v1/runs/#{id}").to_s
    )

    raise NotFound if res['status'] == 404

    res['data']
  end

  def self.raw_user(id)
    res = HTTParty.get(
      URI.parse("http://speedrun.com/api/v1/users/#{id}").to_s
    )

    raise NotFound if res['status'] == 404

    res['data']
  end
end
