class SubscriptionsController < ApplicationController
  before_action :disallow, if: -> { ENV['GOLD'] != '1' }
  before_action :set_stripe_subscription, only: [:show]

  def show
  end

  def create
    if current_user.nil?
      redirect_to subscription_path, alert: 'Please sign in before signing up for Gold. You were not charged.'
      return
    end

    unless ['month', 'year', 'forever'].include?(params[:period])
      redirect_to subscription_path, alert: 'Invalid period.'
      return
    end

    if params[:period] == 'forever'
      begin
        customer = Stripe::Customer.create(
          source: params[:stripeToken],
          email: params[:stripeEmail]
        )
        charge = Stripe::Charge.create(
          customer: customer.id,
          amount: 9000,
          currency: 'usd'
        )

        current_user.update(permagold: true)

        redirect_to subscription_path
      rescue => e
        Rollbar.log('error', e)
        redirect_to subscription_path, alert: 'There was an error processing your payment. Please try again.'
        raise e
      end
      return
    end

    if params[:period] == 'month'
      plan = 'gold-month'
    elsif params[:period] == 'year'
      plan = 'gold-year'
    end

    begin
      customer = Stripe::Customer.create(
        source: params[:stripeToken],
        email: params[:stripeEmail]
      )
      subscription = Stripe::Subscription.create(
        customer: customer.id,
        plan: plan
      )
      current_user.subscriptions.create(
        stripe_customer_id: customer.id,
        stripe_plan_id: plan,
        stripe_subscription_id: subscription.id
      )

      redirect_to subscription_path
    rescue => e
      Rollbar.log('error', e)
      redirect_to subscription_path, alert: 'There was an error processing your payment. Please try again.'
      raise e
    end
    return
  end

  def destroy
    begin
      current_user.subscriptions.each do |subscription|
        stripe_subscription = Stripe::Subscription.retrieve(subscription.stripe_subscription_id)
        stripe_subscription.delete(at_period_end: true)
      end
      current_user.subscriptions.destroy_all

      redirect_to subscription_path, notice: 'Your Gold subscription has been canceled.'
    rescue => e
      Rollbar.log('error', e)
      redirect_to subscription_path, alert: 'There was an error canceling your subscription. Please try again, or email me: qhiiyr@gmail.com'
      raise e
    end
  end

  private

  def set_stripe_subscription
    if current_user.present? && current_user.gold? && !current_user.permagold?
      @subscription = Stripe::Subscription.retrieve(current_user.subscriptions.first.stripe_subscription_id)
    end
  end

  def disallow
    render status: 400, text: 'Gold is turned off for now.'
  end
end
