class SpeedRunsLive
  def self.game(name)
    (HTTParty.get(URI::parse("http://api.speedrunslive.com/games").tap do |uri|
      uri.query = {search: name}.to_param
    end) || {'games' => []}
    )['games'].select { |game| game['name'] == name }[0]
  end
end
