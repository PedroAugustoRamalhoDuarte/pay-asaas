module Pay
  module Asaas
    module Webhooks
      class PaymentSync
        def call(event)
          Pay::Asaas::Charge.sync(event["payment"]["id"], object: event["payment"])

          # TODO: Add notifications
        end
      end
    end
  end
end
