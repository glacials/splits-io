class User < ActiveRecord::Base
  include TwitchUser
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  has_many :runs
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

  def categories_run
    Category.where(
      id: Run.unscoped.where(user: self).select('distinct category_id').where.not(category: nil).map(&:category_id)
    )
  end

  def pb_for(category)
    runs.where(category: category).order(:time).first
  end

  def pbs
    runs.where(
      id: categories_run.map { |category| pb_for(category).id } | runs.where(category: nil).pluck(:id)
    )
  end

  def runs?(category)
    runs.where(category: category).present?
  end

  def to_s
    name || 'somebody'
  end
end
