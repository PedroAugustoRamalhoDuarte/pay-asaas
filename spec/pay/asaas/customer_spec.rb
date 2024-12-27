require "spec_helper"

RSpec.describe Pay::Asaas::Customer do
  let(:user) { User.create!(email: "test@test.com", name: "Pedro Silva") }

  describe "account creation", :vcr do
    context "when the user does not have a processor_id" do
      it "creates a new Asaas customer" do
        payment_processor = user.payment_processor
        expect(payment_processor.api_record).to be_present
      end
    end
  end
end
