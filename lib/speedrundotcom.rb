module SpeedrunDotCom
  class Error < StandardError; end
  class NotFound < Error; end
  class MalformedResponse < Error; end

  class Run
    def self.runner_id(id)
      begin
        res = get(id)
      rescue RestClient::NotFound
        return nil
      end
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
      "https://www.speedrun.com/run/#{id}"
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
      begin
        res = get(id)
      rescue RestClient::NotFound
        return nil
      end
      body = JSON.parse(res.body)
      url = body.try(:[], 'data').try(:[], 'twitch').try(:[], 'uri')
      return nil if url.nil?

      Twitch::User.login_from_url(url)
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
    def route
      RestClient::Resource.new('https://speedrun.com/api/v1')
    end
  end
end
