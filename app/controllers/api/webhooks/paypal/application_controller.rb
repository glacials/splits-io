class Api::Webhooks::Paypal::ApplicationController < ApplicationController
  before_action :verify_signature
  before_action :verify_event_type

  private

  #
  # Returns the ID of the webhook on PayPal's end. This is used by
  # verify_signature to verify the signature of the webhook.
  #
  # This ID is retrievable from
  # https://developer.paypal.com/developer/applications by clicking on your
  # application.
  #
  # To set the ID, coopt the PayPal-designated "event_type" field and
  # concatenate it onto "PAYPAL_WEBHOOK_ID_", and set that key to the webhook
  # ID in `.envrc`.
  #
  # For example, to set the webhook ID for the "Billing subscription activated"
  # webhook, set the environment variable
  # PAYPAL_WEBHOOK_ID_BILLING_SUBSCRIPTION_ACTIVATED to the webhook ID.
  #
  # @return [String] The ID of the webhook.
  #
  def webhook_id
    ENV["PAYPAL_WEBHOOK_ID_#{event_type}"]
  end

  #
  # Verifies that the webhook's signature is a valid PayPal signature for this
  # webhook. This ensures the request came from PayPal, not someone random.
  #
  def verify_signature
    transmission_id = request.headers["PayPal-Transmission-ID"]
    timestamp = request.headers["PayPal-Transmission-Time"]
    crc32 = Zlib::crc32(request.body.string)

    expected_signature = "#{transmission_id}|#{timestamp}|#{webhook_id}|#{crc32}"
    actual_signature = request.headers["PayPal-Transmission-Sig"]

    head(400) if expected_signature != actual_signature

    alg = request.headers["PayPal-Auth-Algo"]

    # I'm not sure why PayPal puts their public key in their webhook headers,
    # because anyone wanting to impersonate them would just swap it with their
    # own public key. Don't use.
    cert = request.headers["PayPal-Cert-Url"]
  end

  #
  # Verifies that the webhook event type is the type that the child controller
  # expects, returning a 400 if not.
  #
  def verify_event_type
    head(400) if params[:event_type] != event_type
  end
end
