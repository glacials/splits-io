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
      "https://www.speedrun.com/run/#{CGI.escape(id)}"
    end

    class << self
      private

      def get(id)
        route(id).get
      end

      def route(id)
        SpeedrunDotCom.route["/runs/#{CGI.escape(id)}"]
      end
    end
  end

  class Game
    def self.search(name)
      JSON.parse(SpeedrunDotCom.route["/games?name=#{CGI.escape(name)}"].get.body)['data']
    end

    def self.from_id(id)
      JSON.parse(SpeedrunDotCom.route["/games/#{CGI.escape(id)}"].get.body)['data']
    end
  end

  class Category
    def self.from_game(srdc_game_id)
      JSON.parse(SpeedrunDotCom.route["/games/#{CGI.escape(srdc_game_id)}/categories"].get.body)['data']
    end

    def self.from_id(id)
      JSON.parse(SpeedrunDotCom.route["/categories/#{CGI.escape(id)}"].get.body)['data']
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
        SpeedrunDotCom.route["/users/#{CGI.escape(id)}"]
      end
    end
  end

  class << self
    def route
      RestClient::Resource.new('https://www.speedrun.com/api/v1')
    end
  end
end
