module Pay
  module Asaas
    # For ASAAS with have 3 options of payments methods: CREDIT_CARD, BOLETO and PIX
    class PaymentMethod < Pay::PaymentMethod
      def self.sync(id, object: nil, try: 0, retries: 1)
        raise NotImplementedError, "Syncing payment methods is not supported yet by the Asaas fake processor"
      end
    end
  end
end
