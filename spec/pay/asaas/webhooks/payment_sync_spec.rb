require "spec_helper"

RSpec.describe Pay::Asaas::Webhooks::PaymentSync do
  let(:event) do
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
  let(:pay_customer) do
    Pay::Asaas::Customer.create!(processor: :asaas, processor_id: event["payment"]["customer"], owner: user)
  end
  let(:order) { Order.create!(name: "test") }

  context "when event is payment_received" do
    it "updates the pay charge status to RECEIVED" do
      pay_charge = Pay::Asaas::Charge.create!(
        processor_id: event["payment"]["id"],
        customer: pay_customer,
        amount: 10,
        status: "PENDING",
        order_id: order.id,
      )
      expect do
        described_class.new.call(event)
        pay_charge.reload
      end.to change(pay_charge, :status).to("RECEIVED")
    end
  end

  context "when there is not a charge in the database" do
    it "does not raise an error" do
      pay_customer
      expect { described_class.new.call(event) }.not_to raise_error
    end
  end
end
