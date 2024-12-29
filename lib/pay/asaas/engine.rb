require "rails/engine"
require "action_dispatch"
require "rails/engine/configuration"

module Pay
  module Asaas
    class Engine < ::Rails::Engine
      engine_name "pay_asaas"

      initializer "pay_asaas.processors" do |app|
        if Pay.automount_routes
          app.routes.append do
            mount Pay::Asaas::Engine, at: Pay.routes_path
          end
        end

        # Include the pay attributes for ActiveRecord models
        ActiveSupport.on_load(:active_record) do
          include Pay::Attributes
        end
      end

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
