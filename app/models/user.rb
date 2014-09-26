class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :runs
  has_many :games, -> { uniq }, through: :runs

  def self.search(term)
    where(User.arel_table[:name].matches "%#{term}%").joins(:runs).uniq.order(:name)
  end

  def load_from_twitch
    response = HTTParty.get("https://api.twitch.tv/kraken/user?oauth_token=#{twitch_token}")

    self.twitch_id = response['_id']
    self.email     = response['email']
    self.name      = response['name']
  end

  def uri
    URI::parse("http://www.twitch.tv/#{name}")
  end

  def as_json(options = {})
    super({
      only: [:id, :twitch_id, :name, :created_at, :updated_at]
    }.merge(options))
  end

  def to_param
    name
  end
end
