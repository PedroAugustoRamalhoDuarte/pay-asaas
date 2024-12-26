module Pay::Asaas
  class ApiClient
    API_KEY = ENV.fetch("ASAAS_API_KEY")
    DEFAULT_PAYMENT_URL = ENV.fetch("ASAAS_API_URL", "https://sandbox.asaas.com/api")
    @base_url = DEFAULT_PAYMENT_URL
    @default_headers = { access_token: API_KEY, "Content-type": "application/json", accept: "application/json" }

    def self.resource_key
      raise NotImplementedError, "You must implement the resource_key method"
    end

    def self.all
      response = HTTParty.get("#{@base_url}/#{resource_key}", headers: @default_headers)
      error_handler(response)
      response.parsed_response
    end

    def self.create(params:)
      response = HTTParty.post("#{@base_url}/#{resource_key}", body: params.to_json, headers: @default_headers)
      error_handler(response)
      response.parsed_response
    end

    def self.update(id:, params:)
      response = HTTParty.get("#{@base_url}/#{resource_key}/#{id}", body: params.to_json, headers: @default_headers)
      error_handler(response)
      response.parsed_response
    end

    def self.find(id:)
      response = HTTParty.get("#{@base_url}/#{resource_key}/#{id}", headers: @default_headers)
      error_handler(response)
      response.parsed_response
    end

    def error_handler(response)
      return unless response.code != 200
      raise StandardError, response["errors"].first["description"] if response["errors"].present?

      Rails.logger.error "Asaas API Error: #{response.code} - #{response.body}"
      raise StandardError, "Ocorreu um erro não identificado na requisição. Por favor, tente novamente mais tarde."
    end
  end
end
