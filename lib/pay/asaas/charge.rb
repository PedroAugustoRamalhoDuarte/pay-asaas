module Pay
  module Asaas
    class Charge < Pay::Charge
      def self.sync(charge_id, object: nil, try: 0, retries: 1)
        object ||= Pay.braintree_gateway.transaction.find(charge_id)

        pay_customer = Pay::Customer.find_by(processor: :asaas, processor_id: object.customer_details.id)
        return unless pay_customer

        ApiClient.create_pix_charge!(
          processor_id: pay_customer.processor_id,
          amount: object.amount,
        )
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        try += 1
        if try <= retries
          sleep 0.1
          retry
        else
          raise
        end
      end

      def api_record
        raise NotImplementedError, "TODO: Implement this method"
      end

      def refund!(amount_to_refund)
        raise NotImplementedError, "Refunding charges is not supported yet by the Asaas fake processor"
      end
    end
  end
end
