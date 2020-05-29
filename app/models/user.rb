class User < ApplicationRecord
  include PgSearch::Model
  include AuthenticatingUser
  include RivalUser
  include RunnerUser

  has_many :runs, dependent: :nullify
  has_many :categories, -> { distinct }, through: :runs
  has_many :games,      -> { distinct }, through: :runs

  has_many :run_likes, dependent: :destroy

  has_many :entries, foreign_key: 'runner_id', dependent: :nullify
  has_many :created_entries, foreign_key: 'creator_id'
  has_many :races, -> { joins(:entries).where(entries: {ghost: false}) }, through: :entries
  has_many :created_races, class_name: 'Race', dependent: :nullify
  has_many :chat_messages, dependent: :nullify

  has_many :rivalries,          foreign_key: :from_user_id, dependent: :destroy, inverse_of: 'from_user'
  has_many :incoming_rivalries, foreign_key: :to_user_id,   dependent: :destroy, inverse_of: 'to_user',
                                class_name: 'Rivalry'

  has_many :twitch_user_follows,   foreign_key: :from_user_id, dependent: :destroy, inverse_of: 'from_user'
  has_many :twitch_user_followers, foreign_key: :to_user_id,   dependent: :destroy, inverse_of: 'to_user',
                                   class_name: 'TwitchUserFollow'

  has_many :twitch_follows,   through: :twitch_user_follows,   source: :to_user
  has_many :twitch_followers, through: :twitch_user_followers, source: :from_user

  has_one :patreon, dependent: :destroy, class_name: 'PatreonUser'
  has_one :twitch,  dependent: :destroy, class_name: 'TwitchUser'
  has_one :google,  dependent: :destroy, class_name: 'GoogleUser'
  has_one :srdc,    dependent: :destroy, class_name: 'SpeedrunDotComUser'

  has_many :subscriptions, dependent: :destroy

  has_many :applications,  class_name: 'Doorkeeper::Application', dependent: :destroy, foreign_key: :owner_id,
                           inverse_of: 'owner'
  has_many :access_grants, class_name: 'Doorkeeper::AccessGrant', dependent: :destroy, foreign_key: :resource_owner_id
  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken', dependent: :destroy, foreign_key: :resource_owner_id

  has_many :sessions, class_name: 'Authie::Session', as: :user, dependent: :destroy

  NAME_REGEX = /\A[A-Za-z0-9_]+\z/.freeze

  validates :name, presence: true, uniqueness: true, format: {with: NAME_REGEX}

  scope :with_runs, -> { joins(:runs).distinct }
  scope :that_run, ->(category) { joins(:runs).where(runs: {category: category}).distinct }
  pg_search_scope :search_for_name, against: :name, using: :trigram

  # STRIPE_MIGRATION_DATE decides what the cutoff date for being grandfathered into features due to a Patreon
  # subscription is.
  STRIPE_MIGRATION_DATE = Time.new('2019', '12', '01').utc

  def self.search(term)
    term = term.strip
    return nil if term.blank?

    search_for_name(term)
  end

  # stay_insideathon is meant to help people deal with COVID-19, conditions where they might find themselves staying
  # indoors a lot. If stay_insideathon returns true, all paid features become available to non-subscribers.
  def self.stay_insideathon?
    false
  end

  def avatar
    [twitch, google].compact.map(&:avatar).first
  end

  def email
    [google, twitch].compact.map(&:email).first
  end

  def to_param
    name.downcase
  end

  def pb_for(timing, category)
    case timing
    when Run::REAL
      runs.where(category: category).order(realtime_duration_ms: :asc).first
    when Run::GAME
      runs.where(category: category).order(gametime_duration_ms: :asc).first
    end
  end

  def pbs
    runs.where.not(category: nil).select('DISTINCT ON (category_id) *').order('category_id, realtime_duration_ms ASC')
        .union_all(runs.by_category(nil))
  end

  # Will filter returned runs to only those from the supplied categories if provided
  # Accepts either an ActiveRecord::Relation of categories or a PORO Array of category ids
  def non_pbs(categories = [])
    query = runs.where.not(id: pbs).where.not(category_id: nil)
    query = query.where(category_id: categories) if categories.present?
    query
  end

  def runs?(category)
    runs.where(category: category).any?
  end

  def to_s
    name || 'somebody'
  end

  # Predictions used to be a tier 2 Patreon feature, so they're available to:
  # 1. Gold users (the standard way of obtaining)
  # 2. Continued patrons who used to have them at the lower price point (grandfathered)
  # 3. Anyone paying at least the price of Gold via Patreon
  def has_predictions?
    patron?(tier: 2, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4) || subscriptions.tier1.active.any? || admin? || self.class.stay_insideathon?
  end

  # Redirectors used to be a tier 3 Patreon feature, so they're available to:
  # 1. Gold users (the standard way of obtaining)
  # 2. Continued patrons who used to have them at the lower price point (grandfathered)
  # 3. Anyone paying at least the price of Gold via Patreon
  def has_redirectors?
    patron?(tier: 3, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4) || subscriptions.tier2.active.any? || admin? || self.class.stay_insideathon?
  end

  # Advanced comparisons used to be a tier 3 Patreon feature, so they're available to:
  # 1. Gold users (the standard way of obtaining)
  # 2. Early patrons (grandfathered as a thank-you)
  # 3. Anyone paying at least the price of Gold via Patreon
  def has_advanced_comparisons?
    patron?(tier: 3, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4) || subscriptions.tier2.active.any? || admin? || self.class.stay_insideathon?
  end

  # Sum-of-best leaderboards used to be free, so they're available to:
  # 1. Gold users (the standard way of obtaining)
  # 2. Early patrons (grandfathered as a thank-you)
  # 3. Anyone paying at least the price of Gold via Patreon
  def has_sum_of_best_leaderboards?
    patron?(tier: 1, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4) || subscriptions.tier1.active.any? || admin? || self.class.stay_insideathon?
  end

  # Hiding used to be free, so it's available to:
  # 1. Gold users (the standard way of obtaining)
  # 2. Early patrons (grandfathered as a thank-you)
  # 3. Anyone paying at least the price of Gold via Patreon
  def has_hiding?
    patron?(tier: 1, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4) || subscriptions.tier1.active.any? || admin? || self.class.stay_insideathon?
  end

  # Advanced video used to be free, so it's available to:
  # 1. Gold users (the standard way of obtaining)
  # 2. Early patrons (grandfathered as a thank-you)
  # 3. Anyone paying at least the price of Gold via Patreon
  def has_advanced_video?
    patron?(tier: 1, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4) || subscriptions.tier1.active.any? || admin? || self.class.stay_insideathon?
  end

  # Auto-highlight used to be free, so it's available to:
  # 1. Gold users (the standard way of obtaining)
  # 2. Early patrons (grandfathered as a thank-you)
  # 3. Anyone paying at least the price of Gold via Patreon
  def has_autohighlight?
    patron?(tier: 1, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4) || subscriptions.tier1.active.any? || admin? || self.class.stay_insideathon?
  end

  # Advanced analytics used to be lower-tier paid Patreon features, so they're available to:
  # 1. Gold users (now the standard way of obtaining)
  # 2. Continued patrons who used to have them at the lower price point (grandfathered)
  # 3. Anyone paying at least the price of Gold via Patreon
  def has_advanced_analytics?
    patron?(tier: 1, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4) || subscriptions.tier1.active.any? || admin? || self.class.stay_insideathon?
  end

  # Speedrun.com auto-submit is the first post-paywall-move paid feature, so is only available to Gold users and
  # those who are paying at least the equivalent at Patreon.
  def has_srdc_submit?
    patron?(tier: 4) || subscriptions.tier3.active.any? || admin? || self.class.stay_insideathon?
  end

  # patron? returns something truthy if the user has been a patron at or above the given tier since the given `before`
  # time. Not passing a `before` is the same as not caring how long the user has been a patron. Tier 4 is an imaginary
  # tier equal to the price of Gold.
  def patron?(tier: 0, before: Time.now.utc)
    return false if patreon&.pledge_created_at.nil? || patreon.pledge_created_at > before

    case tier
    when 0
      patreon.pledge_cents.positive?
    when 1
      patreon.pledge_cents >= 200
    when 2
      patreon.pledge_cents >= 400
    when 3
      patreon.pledge_cents >= 600
    when 4
      patreon.pledge_cents >= 900
    end
  end

  def admin?
    [
      '29798286',  # Glacials
      '18946907',  # Batedurgonnadie
      '461527654', # tuna_can_ball
    ].include?(twitch.try(:twitch_id))
  end

  def likes?(run)
    RunLike.find_by(user: self, run: run)
  end

  def in_race?
    entries.where(finished_at: nil, forfeited_at: nil, ghost: false).any?
  end

  # comprable_runs returns some runs by this user that could be usefully compared to the given run.
  def comparable_runs(timing, run)
    case timing
    when Run::REAL
      Run.where(
        id: runs.select('realtime_duration_ms, MAX(id) AS id')
          .group(:realtime_duration_ms)
          .where(category: run.category)
          .map(&:id)
      ).order(realtime_duration_ms: :asc)
    when Run::GAME
      Run.where(
        id: runs.select('gametime_duration_ms, MAX(id) AS id')
          .group(:gametime_duration_ms)
          .where(category: run.category)
          .map(&:id)
      ).order(gametime_duration_ms: :asc)
    end
  end
end
