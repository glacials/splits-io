class SubscriptionTrialsController < ApplicationController
  def create
    @subscription_trial = SubscriptionTrial.create(user: current_user)
    redirect_back(
      fallback_location: subscriptions_path,
      notice: "Your free trial has started! It will end in #{SubscriptionTrial::TRIAL_DURATION.parts[:days]} days. Enjoy the new features :)",
    )
  end
end
