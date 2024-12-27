require_relative "asaas/version"
require_relative "asaas/inflections"
require "pay/errors"

module Pay
  module Asaas
    autoload :Customer, "pay/asaas/customer"
    autoload :Charge, "pay/asaas/charge"

    class Error < Pay::Error
    end
  end
end
