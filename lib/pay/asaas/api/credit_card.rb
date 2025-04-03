require "pay/asaas/client"
require "pay/asaas/api"

class Pay::Asaas::Api::CreditCard < Pay::Asaas::ApiClient
  def self.resource_key
    "creditCard"
  end

  def self.tokenize(params:)
    request(:post, "creditCards/tokenize", body: params.to_json)
  end
end
