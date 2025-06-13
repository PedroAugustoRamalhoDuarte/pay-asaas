module Pay
  module Asaas
    module Webhooks
      class PaymentSync
        def call(event)
          Pay::Asaas::Charge.sync(event["payment"]["id"], object: event["payment"])
        end
      end
    end
  end
end
