class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :runs

  def load_from_twitch(response = nil)
    response ||= HTTParty.get(URI.parse("https://api.twitch.tv/kraken/user?oauth_token=#{twitch_token}").to_s)

    self.twitch_id = response['_id']
    self.email     = response['email']
    self.name      = response['name']
    self.save
  end
end
