require "pay/asaas/client"
require "pay/asaas/api"

class Pay::Asaas::Api::Payment < Pay::Asaas::ApiClient
  def self.resource_key
    "payments"
  end

  def self.fetch_qr_code(processor_id)
    request(:get, "#{resource_key}/#{processor_id}/pixQrCode")
  end
end
