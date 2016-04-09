class Tugnut
  def self.parse(string)
    JSON.parse(req(string))
  rescue RestClient::BadRequest => e
    e.response
  end

  class << self
    private

    def req(string)
      client.post(splits: string, multipart: true)
    end

    def client
      RestClient::Resource.new('https://tugnut.splits.io/parse/livesplit')
    end
  end
end
