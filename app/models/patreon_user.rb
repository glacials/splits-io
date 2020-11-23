class PatreonUser < ApplicationRecord
  belongs_to :user

  # Predictions used to be a tier 2 Patreon feature, so they're available to:
  # 1. Continued patrons who used to have them at the lower price point
  #    (grandfathered)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_predictions?
    patron?(tier: 2, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4)
  end

  # Redirectors used to be a tier 3 Patreon feature, so they're available to:
  # 1. Continued patrons who used to have them at the lower price point
  #    (grandfathered)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_redirectors?
    patron?(tier: 3, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4)
  end

  # Advanced comparisons used to be a tier 3 Patreon feature, so they're
  # available to:
  # 1. Early patrons (grandfathered as a thank-you)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_advanced_comparisons?
    patron?(tier: 3, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4)
  end

  # Sum-of-best leaderboards used to be free, so they're available to:
  # 1. Early patrons (grandfathered as a thank-you)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_sum_of_best_leaderboards?
    patron?(tier: 1, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4)
  end

  # Hiding used to be free, so it's available to:
  # 1. Early patrons (grandfathered as a thank-you)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_hiding?
    patron?(tier: 1, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4)
  end

  # Advanced video support used to be free, so it's available to:
  # 1. Early patrons (grandfathered as a thank-you)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_advanced_video?
    patron?(tier: 1, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4)
  end

  # Auto-highlighting used to be free, so it's available to:
  # 1. Early patrons (grandfathered as a thank-you)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_autohighlight?
    patron?(tier: 1, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4)
  end

  # Advanced analytics used to be lower-tier paid Patreon features, so they're
  # available to:
  # 1. Continued patrons who used to have them at the lower price point
  #    (grandfathered)
  # 2. Anyone paying at least the price of Gold via Patreon
  def has_advanced_analytics?
    patron?(tier: 1, before: STRIPE_MIGRATION_DATE) || patron?(tier: 4)
  end

  # Speedrun.com auto-submit is the first post-paywall-move paid feature, so is
  # only available to Gold users and those who are paying at least the
  # equivalent at Patreon.
  def has_srdc_submit?
    patron?(tier: 4)
  end

  # patron? returns something truthy if the user has been a patron at or above
  # the given tier since the given `before` time. Not passing a `before` is the
  # same as not caring how long the user has been a patron. Tier 4 is an
  # imaginary tier equal to the price of Gold.
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
end
