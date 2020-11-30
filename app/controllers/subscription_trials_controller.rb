class SubscriptionTrialsController < ApplicationController
  def create
    @subscription_trial = current_user.create_subscription_trial
    redirect_back(
      fallback_location: subscriptions_path,
      notice: "Your free trial has started! It will end on #{@subscription_trial.ended_at}. Enjoy the new features :)",
    )
  end
end
