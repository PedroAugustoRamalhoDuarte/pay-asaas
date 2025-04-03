require "pay/asaas/api/customer"
require "pay/asaas/api/payment"

module Pay
  module Asaas
    class Customer < Pay::Customer
      has_many :charges, dependent: :destroy, class_name: "Pay::Asaas::Charge"
      has_many :payment_methods, dependent: :destroy, class_name: "Pay::Asaas::PaymentMethod"
      has_one :default_payment_method, -> { where(default: true) }, class_name: "Pay::Asaas::PaymentMethod"

      def api_record_attributes
        document = if owner.respond_to?(:document)
          owner.document
        elsif owner.respond_to?(:cpf)
          owner.cpf
        elsif owner.respond_to?(:cnpj)
          owner.cnpj
        else
          raise StandardError, "The document attribute, and it's alternatives are not implemented for #{owner.class}"
        end

        raise StandardError, "The document attribute is required" if document.nil?

        document = document.gsub(/[^\d]/, "")

        { email: email, name: customer_name, cpfCnpj: document, externalReference: owner.id }
      end

      def api_record
        if processor_id?
          Pay::Asaas::Api::Customer.find(id: processor_id)
        else
          customer_response = Pay::Asaas::Api::Customer.create(params: api_record_attributes)
          update!(processor_id: customer_response["id"])
          customer_response
        end
      rescue ApiClient::ApiError => e
        Rails.logger.error "[Pay] Error creating Asaas customer: #{e.message}"
        raise Pay::Asaas::Error, e.message
      end

      def update_api_record(**attributes)
        api_record unless processor_id?
        Pay::Asaas::Api::Customer.update!(id: processor_id, params: api_record_attributes.merge(attributes))
      end

      # Charges only for pix right now
      def charge(amount, options = {})
        # Setup the customer's default payment method
        params = {
          billingType: "PIX",
          dueDate: Time.zone.today.to_s,
          value: amount / 100.0, # Asaas expects a float
        }.merge(options)
          .merge(customer: processor_id || api_record["id"]) # Merge last to not let override customer

        transaction = Pay::Asaas::Api::Payment.create(params: params)

        attrs = {
          amount: amount,
          payment_method_type: "pix",
        }

        attrs = attrs.merge(options[:attrs]) if options[:attrs]

        charge = charges.find_or_initialize_by(processor_id: transaction["id"])
        charge.update(attrs)
        charge
      rescue ApiClient::ApiError => e
        Rails.logger.error "[Pay] Error creating Asaas charge: #{e.message}"
        raise Pay::Asaas::Error, e.message
      end
    end
  end
end
