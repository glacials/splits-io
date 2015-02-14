class User < ActiveRecord::Base
  include RivalUser
  include TwitchUser
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  has_many :runs
  has_many :categories, -> { uniq }, through: :runs
  has_many :games, -> { uniq }, through: :runs
  has_many :rivalries, foreign_key: :from_user_id

  scope :that_run, ->(category) { joins(:runs).where(runs: {category: category}) }

  def self.search(term)
    where(User.arel_table[:name].matches "%#{term}%").joins(:runs).uniq.order(:name)
  end

  def uri
    URI::parse("http://www.twitch.tv/#{name}")
  end

  def to_param
    name
  end

  def pb_for(category)
    Rails.cache.fetch([:users, self, :categories, category, :pb]) do
      runs.where(category: category).order(:time).first
    end
  end

  def pbs
    runs.where(
      id: categories.map { |category| pb_for(category).id } | runs.where(category: nil).pluck(:id)
    )
  end

  def runs?(category)
    runs.where(category: category).present?
  end

  def to_s
    name || 'somebody'
  end
end
