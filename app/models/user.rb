class User < ApplicationRecord
  include PgSearch
  include AuthenticatingUser
  include RivalUser
  include RunnerUser

  has_many :runs
  has_many :categories, -> { distinct }, through: :runs
  has_many :games,      -> { distinct }, through: :runs

  has_many :rivalries,          foreign_key: :from_user_id, dependent: :destroy
  has_many :incoming_rivalries, foreign_key: :to_user_id,   dependent: :destroy, class_name: 'Rivalry'

  has_many :twitch_user_follows,   foreign_key: :from_user_id, dependent: :destroy
  has_many :twitch_user_followers, foreign_key: :to_user_id,   dependent: :destroy, class_name: 'TwitchUserFollow'

  has_many :twitch_follows,   class_name: 'User', through: :twitch_user_follows
  has_many :twitch_followers, class_name: 'User', through: :twitch_user_followers

  has_one  :patreon, class_name: 'PatreonUser', dependent: :destroy
  has_one  :twitch,  class_name: 'TwitchUser',  dependent: :destroy

  has_many :applications,  class_name: 'Doorkeeper::Application', foreign_key: :owner_id
  has_many :access_grants, class_name: 'Doorkeeper::AccessGrant', foreign_key: :resource_owner_id
  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken', foreign_key: :resource_owner_id

  after_destroy do |user|
    user.runs.update_all(user_id: nil)
  end

  validates :name, presence: true

  scope :with_runs, -> { joins(:runs).distinct }
  scope :that_run, ->(category) { joins(:runs).where(runs: {category: category}).distinct }
  pg_search_scope :search_for_name, against: :name, using: :trigram

  def self.search(term)
    term = term.strip
    return nil if term.blank?
    search_for_name(term)
  end

  def avatar
    twitch.avatar
  end

  def uri
    URI.parse("https://www.twitch.tv/#{name}")
  end

  def to_param
    name
  end

  def pb_for(category)
    runs.where(category: category).order(realtime_duration_ms: :asc).first
  end

  def previous_upload_for(category)
    runs.where(category: category).order(created_at: :desc).second
  end

  def pbs
    runs.where.not(category: nil).select('DISTINCT ON (category_id) *').order('category_id, realtime_duration_ms ASC')
        .union_all(runs.by_category(nil))
  end

  def runs?(category)
    runs.where(category: category).any?
  end

  def to_s
    twitch.try(:display_name) || name || 'somebody'
  end

  def should_see_ads?
    !bronze_patron?
  end

  def patron?
    return false if patreon.nil?

    patreon.pledge_cents.positive?
  end

  def bronze_patron?
    return false if patreon.nil?

    patreon.pledge_cents >= 200
  end

  def silver_patron?
    return false if patreon.nil?

    patreon.pledge_cents >= 400
  end

  def gold_patron?
    return false if patreon.nil?

    patreon.pledge_cents >= 600
  end
end
