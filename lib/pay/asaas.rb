require_relative "asaas/version"
require_relative "asaas/inflections"
require "pay/errors"
require "pay/env"

module Pay
  module Asaas
    autoload :Customer, "pay/asaas/customer"
    autoload :Charge, "pay/asaas/charge"

    class Error < Pay::Error
    end

    # Webhooks
    extend Pay::Env

    def self.webhook_access_key
      find_value_by_name(:asaas, :webhook_access_key)
    end

    def self.configure_webhooks
      # https://docs.asaas.com/docs/webhook-para-cobrancas
      Pay::Webhooks.configure do |events|
        events.subscribe "asaas.payment_updated", Pay::Asaas::Webhooks::PaymentSync.new
        events.subscribe "asaas.payment_confirmed", Pay::Asaas::Webhooks::PaymentSync.new
        events.subscribe "asaas.payment_received", Pay::Asaas::Webhooks::PaymentSync.new
        events.subscribe "asaas.payment_overdue", Pay::Asaas::Webhooks::PaymentSync.new
        events.subscribe "asaas.payment_deleted", Pay::Asaas::Webhooks::PaymentSync.new
        events.subscribe "asaas.payment_restored", Pay::Asaas::Webhooks::PaymentSync.new
        events.subscribe "asaas.payment_refunded", Pay::Asaas::Webhooks::PaymentSync.new
      end
    end
  end
end
