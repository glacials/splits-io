class User < ApplicationRecord
  include PgSearch::Model
  include AuthenticatingUser
  include RivalUser
  include RunnerUser

  # current_user is controlled by Authie and is difficult to inject .includes calls into.
  # Relevant issue: https://github.com/adamcooke/authie/issues/42
  #
  # Can also turn this off when upgrading to Rails 7,
  # which allows calling .strict_loading!(false) to bypass the requirement on individual record objects.
  self.strict_loading_by_default = false

  has_many :runs, dependent: :nullify
  has_many :categories, -> { distinct }, through: :runs
  has_many :games, -> { distinct }, through: :runs

  has_many :run_likes, dependent: :destroy

  has_many :entries, foreign_key: "runner_id", dependent: :nullify
  has_many :created_entries, foreign_key: "creator_id"
  has_many :races, -> { joins(:entries).where(entries: { ghost: false }) }, through: :entries
  has_many :created_races, class_name: "Race", dependent: :nullify
  has_many :chat_messages, dependent: :nullify

  has_many :rivalries, foreign_key: :from_user_id, dependent: :destroy, inverse_of: "from_user"
  has_many :incoming_rivalries, foreign_key: :to_user_id, dependent: :destroy, inverse_of: "to_user",
                                class_name: "Rivalry"

  has_one :trial, dependent: :destroy, class_name: "SubscriptionTrial"
  has_one :patreon, dependent: :destroy, class_name: "PatreonUser"
  has_one :twitch, dependent: :destroy, class_name: "TwitchUser"
  has_one :google, dependent: :destroy, class_name: "GoogleUser"
  has_one :srdc, dependent: :destroy, class_name: "SpeedrunDotComUser"

  has_many :subscriptions, dependent: :destroy

  has_many :applications, class_name: "Doorkeeper::Application", dependent: :destroy, foreign_key: :owner_id,
                          inverse_of: "owner"
  has_many :access_grants, class_name: "Doorkeeper::AccessGrant", dependent: :destroy, foreign_key: :resource_owner_id
  has_many :access_tokens, class_name: "Doorkeeper::AccessToken", dependent: :destroy, foreign_key: :resource_owner_id

  has_many :sessions, class_name: "Authie::Session", as: :user, dependent: :destroy

  has_many :password_reset_tokens, dependent: :destroy

  NAME_REGEX = /\A[A-Za-z0-9_]+\z/.freeze
  PASSWORD_REGEX = /\A.{8,}+\z/.freeze

  # Turn off default password validations because they include a presence
  # validation, which we don't require as some accounts can be link-only. But
  # turn on the other validations manually -- validating that `password` and
  # `password_confirmation` match when both supplied, and max length.
  #
  # Although it's theoretically bad to have max lengths on passwords, BCrypt
  # truncates at 72 bytes, so we should enforce that here rather than let users
  # pass in 73 bytes and be surprised that we only use the first 72.
  has_secure_password(validations: false)
  validates_confirmation_of :password, allow_blank: true
  validates_length_of :password, maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED

  validates :name, presence: true, uniqueness: true, format: { with: NAME_REGEX }
  validates :email, uniqueness: { allow_nil: true } # Cannot validate non-null as some old users do not have emails

  scope :with_runs, -> { joins(:runs).distinct }
  scope :that_run, ->(category) { joins(:runs).where(runs: { category: category }).distinct }
  pg_search_scope :search_for_name, against: :name, using: :trigram

  # STRIPE_MIGRATION_DATE decides what the cutoff date for being grandfathered into features due to a Patreon
  # subscription is.
  STRIPE_MIGRATION_DATE = Time.new("2019", "12", "01").utc

  def self.search(term)
    term = term.strip
    return nil if term.blank?

    search_for_name(term)
  end

  def avatar
    [twitch, google].compact.map(&:avatar).first
  end

  def to_param
    name.downcase
  end

  def pb_for(timing, category)
    case timing
    when Run::REAL
      runs.includes(:segments).where(category: category).order(realtime_duration_ms: :asc).first
    when Run::GAME
      runs.includes(:segments).where(category: category).order(gametime_duration_ms: :asc).first
    end
  end

  def pbs
    runs.where.not(category: nil).select("DISTINCT ON (category_id) *").order("category_id, realtime_duration_ms ASC")
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
    name || "somebody"
  end

  # feature_grantors returns an array of objects that can give the user
  # features, like a subscription, a grandfathered patreon subscription, or a
  # trial. Every feature grantor must implement all `has_FEATURE?`-type methods
  # below.
  #
  # If the feature grantor resolves to nil, it is assumed that it grants no
  # features.
  def feature_grantors
    # TODO: Convert subscriptions from has-many to has-one
    [patreon, subscriptions, trial].compact
  end

  def has_predictions?
    feature_grantors.any?(&__method__)
  end

  def has_redirectors?
    feature_grantors.any?(&__method__)
  end

  def has_advanced_comparisons?
    feature_grantors.any?(&__method__)
  end

  def has_sum_of_best_leaderboards?
    feature_grantors.any?(&__method__)
  end

  def has_hiding?
    feature_grantors.any?(&__method__)
  end

  def has_advanced_video?
    feature_grantors.any?(&__method__)
  end

  def has_autohighlight?
    feature_grantors.any?(&__method__)
  end

  def has_advanced_analytics?
    feature_grantors.any?(&__method__)
  end

  def has_srdc_submit?
    feature_grantors.any?(&__method__)
  end

  def admin?
    [
      "29798286",  # Glacials
      "18946907",  # Batedurgonnadie
      "461527654", # tuna_can_ball
    ].include?(twitch&.twitch_id)
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
        id: runs.select("realtime_duration_ms, MAX(id) AS id")
          .group(:realtime_duration_ms)
          .where(category: run.category)
          .map(&:id),
      ).order(realtime_duration_ms: :asc)
    when Run::GAME
      Run.where(
        id: runs.select("gametime_duration_ms, MAX(id) AS id")
          .group(:gametime_duration_ms)
          .where(category: run.category)
          .map(&:id),
      ).order(gametime_duration_ms: :asc)
    end
  end
end
