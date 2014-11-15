class User < ActiveRecord::Base
  include TwitchUser
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  has_many :runs
  has_many :games, -> { uniq }, through: :runs

  scope :that_run, ->(category) { joins(:runs).where(runs: {category: category}) }

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

  def pb_for(category)
    runs.where(category: category).order(:time).first
  end

  def runs?(category)
    runs.where(category: category).present?
  end
end
