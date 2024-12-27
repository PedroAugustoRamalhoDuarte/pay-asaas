require_relative "asaas/version"
require_relative "asaas/inflections"

module Pay
  module Asaas
    autoload :Customer, "pay/asaas/customer"
  end
end
