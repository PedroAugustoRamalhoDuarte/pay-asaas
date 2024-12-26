class Pay::Asaas::Api::Customer < Pay::Asaas::ApiClient
  # Set notificationDisabled by default
  def self.create(params:)
    params[:notificationDisabled] = true if params[:notificationDisabled].blank?

    super
  end
end
