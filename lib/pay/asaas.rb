require_relative "asaas/version"
require_relative "asaas/inflections"
require "pay/errors"

module Pay
  module Asaas
    autoload :Customer, "pay/asaas/customer"

    class Error < Pay::Error
    end
  end
end
