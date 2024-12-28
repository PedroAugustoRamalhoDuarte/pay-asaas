module Pay
  module Webhooks
    class AsaasController < Pay::ApplicationController
      if Rails.application.config.action_controller.default_protect_from_forgery
        skip_before_action :verify_authenticity_token
      end

      def create
        if valid_signature?(request.headers["asaas-access-token"])
          queue_event(verify_params.as_json)
          head :ok
        else
          head :bad_request
        end
      rescue Pay::Asaas::Error => e
        log_error(e)
        head :bad_request
      end

      private

      def queue_event(event)
        return unless Pay::Webhooks.delegator.listening?("asaas.#{event[:event]&.downcase}")

        record = Pay::Webhook.create!(processor: :asaas, event_type: event.type, event: event)
        Pay::Webhooks::ProcessJob.perform_later(record)
      end

      def valid_signature?(signature)
        signature == Pay::Assas.webhook_access_token
      end

      def log_error(e)
        logger.error e.message
        e.backtrace.each { |line| logger.error "  #{line}" }
      end

      def verify_params
        params.except(:action, :controller).permit!
      end
    end
  end
end
