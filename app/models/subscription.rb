class Subscription < ActiveRecord::Base
  belongs_to :user

  scope :active,   -> { where(ended_at: nil) }
  scope :canceled, -> { where.not(canceled_at: nil) }
  scope :is_tier1, -> { where(stripe_plan_id: ENV['STRIPE_PLAN_ID_TIER1']) }
  scope :is_tier2, -> { where(stripe_plan_id: ENV['STRIPE_PLAN_ID_TIER2']) }
  scope :is_tier3, -> { where(stripe_plan_id: ENV['STRIPE_PLAN_ID_TIER3']) }
  scope :tier1,    -> { is_tier1.or(is_tier2).or(is_tier3) }
  scope :tier2,    -> { is_tier2.or(is_tier3) }
  scope :tier3,    -> { is_tier3 }

  def tier?(tier)
    case tier
    when 1
      [ENV['STRIPE_PLAN_ID_TIER1'], ENV['STRIPE_PLAN_ID_TIER2']].include?(stripe_plan_id)
    when 2
      stripe_plan_id == ENV['STRIPE_PLAN_ID_TIER2']
    when 3
      stripe_plan_id == ENV['STRIPE_PLAN_ID_TIER3']
    end
  end

  def canceled?
    canceled_at.present?
  end

  def ended?
    ended_at.present?
  end

  def change_plan!(stripe_plan_id)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']

    # First we need the Subscription Item ID
    subscription = Stripe::Subscription.retrieve(stripe_subscription_id)

    Stripe::Subscription.update(
      stripe_subscription_id,
      cancel_at_period_end: false,
      items: [{
        id: subscription.items.data[0].id,
        plan: stripe_plan_id,
      }],
    )
    update(
      canceled_at: nil,
      stripe_plan_id: stripe_plan_id,
    )
  end

  def cancel!
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    Stripe::Subscription.update(
      stripe_subscription_id,
      cancel_at_period_end: true,
    )
    update(canceled_at: Time.now.utc)
  end

  def self.cancel_all!
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']

    active.find_each do |subscription|
      Stripe::Subscription.update(
        subscription.stripe_subscription_id,
        cancel_at_period_end: true,
      )
    end

    # Set canceled_at now; ended_at will be set by a Stripe webhook when the month runs out
    where(canceled_at: nil).update_all(canceled_at: Time.now.utc)
  end
end
