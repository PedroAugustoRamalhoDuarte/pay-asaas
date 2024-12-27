require "pay/asaas/client"
require "pay/asaas/api"

class Pay::Asaas::Api::Payment < Pay::Asaas::ApiClient
  def self.resource_key
    "payments"
  end
end
