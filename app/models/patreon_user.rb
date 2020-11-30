class PatreonUser < ApplicationRecord
  belongs_to :user

  # Predictions used to be a tier 2 Patreon feature, so they're available to:
  # 1. Continued patrons who used to have them at the lower price point
  #    (grandfathered)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_predictions?
    active?(tier: 2, since_before: STRIPE_MIGRATION_DATE) || active?(tier: 4)
  end

  # Redirectors used to be a tier 3 Patreon feature, so they're available to:
  # 1. Continued patrons who used to have them at the lower price point
  #    (grandfathered)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_redirectors?
    active?(tier: 3, since_before: STRIPE_MIGRATION_DATE) || active?(tier: 4)
  end

  # Advanced comparisons used to be a tier 3 Patreon feature, so they're
  # available to:
  # 1. Early patrons (grandfathered as a thank-you)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_advanced_comparisons?
    active?(tier: 3, since_before: STRIPE_MIGRATION_DATE) || active?(tier: 4)
  end

  # Sum-of-best leaderboards used to be free, so they're available to:
  # 1. Early patrons (grandfathered as a thank-you)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_sum_of_best_leaderboards?
    active?(tier: 1, since_before: STRIPE_MIGRATION_DATE) || active?(tier: 4)
  end

  # Hiding used to be free, so it's available to:
  # 1. Early patrons (grandfathered as a thank-you)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_hiding?
    active?(tier: 1, since_before: STRIPE_MIGRATION_DATE) || active?(tier: 4)
  end

  # Advanced video support used to be free, so it's available to:
  # 1. Early patrons (grandfathered as a thank-you)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_advanced_video?
    active?(tier: 1, since_before: STRIPE_MIGRATION_DATE) || active?(tier: 4)
  end

  # Auto-highlighting used to be free, so it's available to:
  # 1. Early patrons (grandfathered as a thank-you)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_autohighlight?
    active?(tier: 1, since_before: STRIPE_MIGRATION_DATE) || active?(tier: 4)
  end

  # Advanced analytics used to be lower-tier paid Patreon features, so they're
  # available to:
  # 1. Continued patrons who used to have them at the lower price point
  #    (grandfathered)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_advanced_analytics?
    active?(tier: 1, since_before: STRIPE_MIGRATION_DATE) || active?(tier: 4)
  end

  # Speedrun.com auto-submit is the first post-paywall-move paid feature, so is
  # only available to Gold users and those who are paying at least the
  # equivalent at Patreon.
  def has_srdc_submit?
    active?(tier: 4)
  end

  # active? returns something truthy if the user has been a patron at or above
  # the given tier since the given `since_before` time. Not passing
  # `since_before` is the same as not caring how long the user has been a
  # patron. Tier 4 is an imaginary tier equal to the price of Gold.
  def active?(tier: 0, since_before: Time.now.utc)
    return false if pledge_created_at.nil? || pledge_created_at > since_before

    case tier
    when 0
      pledge_cents.positive?
    when 1
      pledge_cents >= 200
    when 2
      pledge_cents >= 400
    when 3
      pledge_cents >= 600
    when 4
      pledge_cents >= 900
    end
  end
end
