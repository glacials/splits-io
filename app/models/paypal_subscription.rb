# Represents a subscription fulfilled by PayPal. A PayPalSubscription is a
# one-to-one relationship with an _active_ subscription on PayPal's end. This
# lifecycle is managed by webhooks, whose receivers are located in
# [app/controllers/api/webhooks/paypal_controller.rb].
class PaypalSubscription < ApplicationRecord
  belongs_to :user

  before_destroy :cancel!

  def cancel!
    PayPal.cancel(provider_subscription_id)
    # We do not have to destroy ourselves, because PayPal will bounce back a
    # webhook on success which will trigger our destruction
  end

  def has_predictions?
    true
  end

  def has_redirectors?
    true
  end

  def has_advanced_comparisons?
    true
  end

  def has_sum_of_best_leaderboards?
    true
  end

  def has_hiding?
    true
  end

  def has_advanced_video?
    true
  end

  def has_autohighlight?
    true
  end

  def has_advanced_analytics?
    true
  end

  def has_srdc_submit?
    true
  end
end
