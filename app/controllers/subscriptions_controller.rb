class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[update destroy]

  def index
  end

  def show
  end

  def update
    @subscription.change_plan!(subscription_params[:stripe_plan_id])

    redirect_to(subscriptions_path, notice: 'Subscription plan changed!')
  end

  # This endpoint is only hit by first party JavaScript
  def destroy
    @subscription.cancel!

    redirect_to(subscriptions_path, notice: 'Subscription canceled.')
  end

  private

  def set_subscription
    @subscription = current_user.subscriptions.active.first
  end

  def subscription_params
    params.require(:subscription).permit(:stripe_plan_id)
  end
end
