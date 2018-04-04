module SpeedrunDotCom
  class Error < StandardError; end
  class NotFound < Error; end
  class MalformedResponse < Error; end

  class Run
    def self.runner_id(id)
      res = get(id)
      body = JSON.parse(res.body)

      body['data']['players'][0]['id']
    end

    def self.id_from_url(url)
      return nil if url.blank?

      uri = URI.parse(url)
      return false unless uri.host =~ /^(www\.)?(speedrun.com)$/ && uri.path =~ %r{^(?:/.*?)?/run/(.*)$}

      %r{^(?:/.*?)?/run/(.*)$}.match(uri.path)[1]
    end

    def self.url_from_id(id)
      return nil if id.blank?
      "http://www.speedrun.com/run/#{id}"
    end

    class << self
      private

      def get(id)
        route(id).get
      end

      def route(id)
        SpeedrunDotCom.route["/runs/#{id}"]
      end
    end
  end

  class User
    def self.twitch_login(id)
      res = get(id)
      body = JSON.parse(res.body)

      Twitch::User.login_from_url(body['data']['twitch']['uri'])
    end

    class << self
      private

      def get(id)
        route(id).get
      end

      def route(id)
        SpeedrunDotCom.route["/users/#{id}"]
      end
    end
  end

  class << self
    private

    def route
      RestClient::Resource.new('http://speedrun.com/api/v1')
    end
  end
end
