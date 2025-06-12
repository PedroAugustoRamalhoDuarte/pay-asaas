require "pay/asaas/api/payment"

module Pay
  module Asaas
    class Charge < Pay::Charge
      store_accessor :data, :status
      store_accessor :data, :pix_code
      after_create :sync_pix_qr_code

      def self.sync(charge_id, object: nil, try: 0, retries: 1)
        object ||= Pay::Asaas::Api::Payment.find(id: charge_id)

        customer_processor_id = get_attribute(object, :customer)
        charge_processor_id = get_attribute(object, :id)
        pay_customer = Pay::Customer.find_by(processor: :asaas, processor_id: customer_processor_id)

        # rubocop:disable Layout/LineLength
        if pay_customer.blank?
          Rails.logger.debug do
            "Pay::Customer #{customer_processor_id} is not in the database while syncing Asaas Charge #{charge_processor_id}"
          end
          return
        end
        # rubocop:enable Layout/LineLength

        attrs = {
          amount: get_attribute(object, :value).to_f * 100,
          status: get_attribute(object, :status),
        }

        # Update or create the charge
        if (pay_charge = pay_customer.charges.find_by(processor_id: charge_processor_id))
          pay_charge.with_lock do
            pay_charge.update!(attrs)
          end
          pay_charge
        else
          pay_customer.charges.create!(attrs.merge(processor_id: charge_processor_id))
        end
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        try += 1
        if try <= retries
          sleep 0.1
          retry
        else
          raise
        end
      end

      def self.get_attribute(obj, attr_name)
        return obj[attr_name.to_s] if obj.is_a?(Hash)
        return obj.send(attr_name) if obj.respond_to?(attr_name)

        nil
      end

      def api_record
        Pay::Asaas::Api::Payment.find(id: processor_id)
      rescue ApiClient::ApiError => e
        raise Pay::Asaas::Error, e
      end

      def refund!(amount_to_refund)
        raise NotImplementedError, "Refunding charges is not supported yet by the Asaas fake processor"
      end

      def sync_pix_qr_code
        return unless payment_method_type == "pix"

        response = Pay::Asaas::Api::Payment.fetch_qr_code(processor_id)

        update!(
          pix_code: response["payload"],
        )
      end
    end
  end
end
