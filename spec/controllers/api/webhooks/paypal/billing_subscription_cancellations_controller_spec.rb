require "rails_helper"

describe Api::Webhooks::Paypal::BillingSubscriptionCancellationsController do
  describe "#create" do
    subject(:response) { post :create }

    context "with no signature" do
      it "returns a 400" do
        expect(response).to have_http_status 400
      end
    end

    context "with an invalid signature" do
      before { request.headers["PayPal-Transmission-Sig"] = "nonsense" }

      it "returns a 400" do
        expect(response).to have_http_status 400
      end
    end

    context "with a valid signature" do
      before do
        request.headers["Content-Type"] = "application/json"

        transmission_id = SecureRandom.uuid
        request.headers["PayPal-Transmission-ID"] = transmission_id

        timestamp = SecureRandom.uuid
        request.headers["PayPal-Transmission-Time"] = timestamp

        webhook_id = ENV["PAYPAL_WEBHOOK_ID_BILLING_SUBSCRIPTION_CANCELLED"]
        crc32 = Zlib::crc32(request_body.to_json)

        request.headers["PayPal-Transmission-Sig"] = "#{transmission_id}|#{timestamp}|#{webhook_id}|#{crc32}"
      end

      context "and no event type" do
        let(:request_body) { {} }
        subject(:response) { post :create }

        it "returns a 400" do
          expect(response).to have_http_status 400
        end
      end

      context "and an incorrect event type" do
        let(:request_body) do
          {
            event_type: "nonsense",
            resource: {
              id: SecureRandom.uuid, plan_id: SecureRandom.uuid,
            },
          }
        end
        subject(:response) { post :create, body: request_body.to_json }

        it "returns a 400" do
          expect(response).to have_http_status 400
        end
      end

      context "and a correct event type" do
        let(:request_body) do
          {
            event_type: "BILLING.SUBSCRIPTION.CANCELLED",
            resource: {
              id: SecureRandom.uuid,
              plan_id: SecureRandom.uuid,
            },
          }
        end
        subject(:response) { post :create, body: request_body.to_json }

        it "returns a 200" do
          expect(response).to have_http_status 204
        end
      end
    end
  end
end
