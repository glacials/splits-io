class Tugnut
  def self.parse(string)
    JSON.parse(req(string))
  rescue RestClient::BadRequest => e
    e.response
  end

  private

  def self.req(string)
    client.post(splits: string, multipart: true)
  end

  def self.client
    RestClient::Resource.new('https://tugnut.splits.io/parse/livesplit')
  end
end
