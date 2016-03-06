module SpeedrunDotCom
  class Error < StandardError
    class NotFound; end
    class MalformedResponse; end
  end

  class Run
    def self.runner_id(id)
      res = get(id)
      body = JSON.parse(res.body)

      raise MalformedResponse unless body.respond_to?(:[])
      raise MalformedResponse unless body['data'].respond_to?(:[])
      raise MalformedResponse unless body['data']['players'].respond_to?(:[])
      raise MalformedResponse unless body['data']['players'][0].respond_to?(:[])
      raise MalformedResponse unless body['data']['players'][0]['id'].present?

      body['data']['players'][0]['id']
    end

    def self.id_from_url(url)
      if url.blank?
        return nil
      end

      uri = URI.parse(url)
      unless uri.host =~ /^(www\.)?(speedrun.com)$/ && uri.path =~ /^\/run\/(.*)$/
        return false
      end

      /^\/run\/(.*)$/.match(uri.path)[1]
    end

    def self.url_from_id(id)
      return nil if id.blank?
      "http://www.speedrun.com/run/#{id}"
    end

    private

    def self.get(id)
      route(id).get
    end

    def self.route(id)
      SpeedrunDotCom.route["/runs/#{id}"]
    end
  end

  class User
    def self.twitch_login(id)
      res = get(id)
      body = JSON.parse(res.body)

      raise MalformedResponse unless body.respond_to?(:[])
      raise MalformedResponse unless body['data'].respond_to?(:[])
      raise MalformedResponse unless body['data']['twitch'].respond_to?(:[])
      raise MalformedResponse unless body['data']['twitch']['uri'].present?

      Twitch::User.login_from_url(body['data']['twitch']['uri'])
    end

    private

    def self.get(id)
      route(id).get
    end

    def self.route(id)
      SpeedrunDotCom.route["/users/#{id}"]
    end
  end

  private

  def self.route
    RestClient::Resource.new('http://speedrun.com/api/v1')
  end
end
