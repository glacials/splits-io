class SpeedRunsLive
  class Game
    def self.from_shortname(shortname)
      HTTParty.get(URI.parse("http://api.speedrunslive.com/games/#{shortname}"))
    rescue Errno::ETIMEDOUT
      nil
    end

    def self.from_name(name)
      ((HTTParty.get(URI.parse('http://api.speedrunslive.com/games').tap do |uri|
        uri.query = {search: name}.to_param
      end))['games'] || []).select { |game| game['name'] == name }[0]
    rescue Errno::ETIMEDOUT
      nil
    end
  end
end
