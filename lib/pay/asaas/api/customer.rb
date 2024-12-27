require "pay/asaas/client"
require "pay/asaas/api"

class Pay::Asaas::Api::Customer < Pay::Asaas::ApiClient
  def self.resource_key
    "customers"
  end

  # Set notificationDisabled by default
  def self.create(params:)
    params[:notificationDisabled] = true if params[:notificationDisabled].blank?

    super
  end
end
