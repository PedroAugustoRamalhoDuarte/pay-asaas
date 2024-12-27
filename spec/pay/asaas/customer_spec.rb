require "spec_helper"

RSpec.describe Pay::Asaas::Customer do
  let(:user) { User.create!(email: "test@test.com", name: "Pedro Silva") }

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
end
