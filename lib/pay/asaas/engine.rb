module Pay
  module Asaas
    class Engine < ::Rails::Engine
      engine_name "pay_asaas"

      # Add webhook subscribers before app initializers define extras
      # This keeps the processing in order so that changes have happened before user-defined webhook processors
      config.before_initialize do
        Pay::Asaas.configure_webhooks if Pay::Asaas.enabled?
      end

      config.to_prepare do
        Pay::Asaas.setup if Pay::Asaas.enabled?
      end
    end
  end
end
