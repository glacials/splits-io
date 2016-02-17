module SpeedrunDotCom
  class RunNotFound < StandardError; end
  class UserNotFound < StandardError; end
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

    if [r['id'], r['players']].any?(&:blank?)
      raise RunNotFound
    end

    Run.new(r)
  end

  def self.user(id)
    u = raw_user(id)

    if [u['id'], u['twitch'], u['uri']].any?(&:blank?)
      raise UserNotFound
    end

    User.new(u)
  end

  private

  def self.raw_run(id)
    r = HTTParty.get(
      URI.parse("http://speedrun.com/api/v1/runs/#{id}").to_s
    )['data']

    raise ServerError unless r.respond_to?(:[])
    r
  end

  def self.raw_user(id)
    u = HTTParty.get(
      URI.parse("http://speedrun.com/api/v1/users/#{id}").to_s
    )['data']

    raise ServerError unless u.respond_to?(:[])
    u
  end
end
