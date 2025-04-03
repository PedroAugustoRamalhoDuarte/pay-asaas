require "spec_helper"

RSpec.describe Pay::Asaas::Customer do
  let(:user) { User.create!(email: "test@test.com", name: "Pedro Silva", document: "20218405065") }
  let(:valid_cpf) { "20218405065" }

  describe "account creation", :vcr do
    context "when the user does not have a processor_id" do
      it "creates a new Asaas customer" do
        payment_processor = user.payment_processor
        expect(payment_processor.api_record["name"]).to eq("Pedro Silva")
        expect(user.payment_processor.processor_id).to be_present
      end
    end

    context "when user does not have an name" do
      it "expects to return an error" do
        user.update!(name: nil)
        expect { user.payment_processor.api_record }.to raise_error(Pay::Asaas::Error)
      end
    end
  end

  describe "#charge", :vcr do
    let(:order) { Order.create!(name: "test") }

    context "when user does not have document" do
      it "returns an error" do
        expect { user.payment_processor.charge(10_00) }.to raise_error(Pay::Asaas::Error)
      end
    end

    it "creates a new charge" do # rubocop:disable RSpec/MultipleExpectations
      user.document = valid_cpf
      expect do
        user.payment_processor.charge(10_00, { attrs: { order_id: order.id } })
      end.to change(user.payment_processor.charges, :count).by(1)
      expect(user.payment_processor.charges.first.amount).to eq(10_00)
      expect(user.payment_processor.charges.first.class).to eq(Pay::Asaas::Charge)
      expect(user.payment_processor.charges.first.payment_method_type).to eq("pix")
      expect(user.payment_processor.charges.first.pix_code).to be_present
    end
  end
end
