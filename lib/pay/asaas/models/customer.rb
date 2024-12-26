class Pay::Asaas::Api::Customer < Pay::Asaas::ApiClient
  # Set notificationDisabled by default
  def self.create(params:)
    params[:notificationDisabled] = true unless params[:notificationDisabled].present?

    super(params: params)
  end
end
