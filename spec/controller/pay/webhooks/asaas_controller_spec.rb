require "spec_helper"
require "pay/engine"

RSpec.describe Pay::Webhooks::AsaasController, type: :request do
  include Pay::Engine.routes.url_helpers

  describe "POST #create" do
    let(:params) do
      {
        "id" => "evt_123",
        "event" => "PAYMENT_RECEIVED",
        "payment" => {
          "id" => "pay_123",
          "customer" => "cus_123",
          "value" => 1000.0,
          "status" => "RECEIVED",
        },
        # There are more fields in the webhook payload
      }
    end
    let(:user) { User.create!(email: "test@test.com", name: "Pedro Silva", document: "20218405065") }

    context "when the request is not authenticated" do
      it "returns bad request" do
        post "/pay/webhooks/asaas", params: {}, headers: { "asaas-access-token": "my-secret-token-from-asaas" }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when the event is valid" do
      let(:order) { Order.create!(name: "test") }

      let(:pay_customer) do
        Pay::Asaas::Customer.create!(processor: :asaas, processor_id: params["payment"]["customer"], owner: user)
      end

      it "returns success and created Pay::Webhook" do
        Pay::Asaas::Charge.create!(
          processor_id: params["payment"]["id"],
          customer: pay_customer,
          amount: 10,
          order_id: order.id,
        )
        expect { post "/pay/webhooks/asaas", params: params }.to change(Pay::Webhook, :count).by(1)
        expect(response).to have_http_status(:success)
      end
    end

    context "when does not have charge in the database" do
      it "returns success and created Pay::Webhook" do
        expect { post "/pay/webhooks/asaas", params: params }.to change(Pay::Webhook, :count).by(1)
        expect(response).to have_http_status(:success)
      end
    end
  end
end
