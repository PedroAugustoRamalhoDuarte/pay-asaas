module Pay
  module Asaas
    class Customer < Pay::Customer
      has_many :charges, dependent: :destroy, class_name: "Pay::Asaas::Charge"
      has_many :payment_methods, dependent: :destroy, class_name: "Pay::Asaas::PaymentMethod"
      has_one :default_payment_method, -> { where(default: true) }, class_name: "Pay::Asaas::PaymentMethod"

      def api_record_attributes
        # TODO: where to format document
        { email: email, name: customer_name, cpfCnpj: owner.document, externalReference: owner.id }
      end

      # TODO: what to return in this method?
      def api_record
        if processor_id?
          Pay::Asaas::Api::Customer.find(id: processor_id)
        else
          customer_response = Pay::Asaas::Api::Customer.create(api_record_attributes)
          update!(processor_id: customer_response["id"]) # TODO: is not updating
          customer_response
        end
      rescue => e
        # TODO: Handle error better
        Rails.logger.error "[Pay] Error creating Asaas customer: #{e.message}"
        # raise Pay::Stripe::Error, e
      end

      def update_api_record(**attributes)
        api_record unless processor_id?
        Pay::Asaas::Api::Customer.update!(id: processor_id, params: api_record_attributes.merge(attributes))
      end

      # Charges an amount to the customer's default payment method
      def charge(amount, options = {})
        transaction = ApiClient.create_pix_charge!(
          processor_id: processor_id,
          amount: amount,
          other_params: options.merge(dueDate: Time.zone.today.to_s),
          )

        Rails.logger.debug transaction
        attrs = {
          amount: amount,
        }

        charge = charges.find_or_initialize_by(processor_id: transaction["id"])
        charge.update(attrs)
        charge
      rescue StandardError => e
        Rails.logger.error "[Pay] Error creating Asaas charge: #{e.message}"
      end
    end
  end
end