class SubscriptionsController < ApplicationController
  def new
  end

  def create
    unless ['month', 'year', 'forever'].include?(params[:period])
      redirect_to new_subscription_path, alert: 'Invalid period.'
      return
    end

    begin
      case params[:period]
      when 'month'
        customer = Stripe::Customer.create(
          source: params[:stripeToken],
          email: params[:stripeEmail],
          plan: 'gold-month'
        )
        current_user.update(stripe_id: customer.id)
      when 'year'
        customer = Stripe::Customer.create(
          source: params[:stripeToken],
          email: params[:stripeEmail],
          plan: 'gold-year'
        )
        current_user.update(stripe_id: customer.id)
      when 'forever'
        customer = Stripe::Customer.create(
          source: params[:stripeToken],
          email: params[:stripeEmail]
        )
        charge = Stripe::Charge.create(
          customer: customer.id,
          amount: 9000
        )
        current_user.update(stripe_id: customer.id)
      end
    rescue => e
      Rollbar.log('error', e)
      redirect_to new_subscription_path, alert: 'There was an error processing your payment. Please try again.'
    end
  end
end
