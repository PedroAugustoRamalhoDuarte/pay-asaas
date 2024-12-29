require_relative "asaas/version"
require_relative "asaas/inflections"
require "pay/asaas/engine"
require "pay/asaas/client"
require "pay/errors"
require "pay/env"

module Pay
  module Asaas
    autoload :Customer, "pay/asaas/customer"
    autoload :Charge, "pay/asaas/charge"

    class Error < Pay::Error
    end

    module Webhooks
      autoload :PaymentSync, "pay/asaas/webhooks/payment_sync"
    end

    # Setup configuration

    # If users imports this gem its enable by default
    def self.enabled?
      true
    end

    def self.setup
      # Configure api client key in this setup
      Pay::Asaas::ApiClient.configure do |config|
        config.api_key = Pay::Asaas.api_key
        config.base_url = Pay::Asaas.api_url
      end
    end

    extend Pay::Env

    def self.api_key
      find_value_by_name(:asaas, :api_key)
    end

    def self.api_url
      find_value_by_name(:asaas, :api_url) || "https://sandbox.asaas.com/api/v3"
    end

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
