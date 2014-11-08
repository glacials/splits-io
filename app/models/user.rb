class User < ActiveRecord::Base
  include TwitchUser
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  has_many :runs
  has_many :games, -> { uniq }, through: :runs

  def self.search(term)
    where(User.arel_table[:name].matches "%#{term}%").joins(:runs).uniq.order(:name)
  end

  def uri
    URI::parse("http://www.twitch.tv/#{name}")
  end

  def as_json(options = {})
    {
      id:         id,
      twitch_id:  twitch_id,
      name:       name,
      created_at: created_at,
      updated_at: updated_at
    }
  end

  def to_param
    name
  end
end
