require "httparty"

module Pay::Asaas
  class ApiClient
    class Error < StandardError; end
    class ConfigurationError < Error; end
    class ApiError < Error; end

    class Configuration
      attr_accessor :api_key, :base_url

      def initialize
        @api_key = ENV["ASAAS_API_KEY"]
        @base_url = ENV["ASAAS_API_URL"] || "https://sandbox.asaas.com/api/v3"
      end

      def validate!
        raise ConfigurationError, "API key is required" unless api_key
      end
    end

    class << self
      attr_writer :configuration

      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
      end

      def headers
        {
          access_token: configuration.api_key,
          "content-type": "application/json",
          accept: "application/json",
        }
      end

      def resource_key
        raise NotImplementedError, "You must implement the resource_key method"
      end

      def request(method, path, options = {})
        configuration.validate!
        response = HTTParty.send(
          method,
          "#{configuration.base_url}/#{path}",
          { headers: headers }.merge(options),
        )
        handle_response(response)
      end

      def all
        request(:get, resource_key)
      end

      def create(params:)
        request(:post, resource_key, body: params.to_json)
      end

      def update(id:, params:)
        request(:put, "#{resource_key}/#{id}", body: params.to_json)
      end

      def find(id:)
        request(:get, "#{resource_key}/#{id}")
      end

      private

      def handle_response(response)
        return response.parsed_response if response.success?

        error_message = if response.parsed_response && response.parsed_response["errors"]&.first
          response.parsed_response["errors"].first["description"]
        else
          "Request failed with status #{response.code}"
        end

        Rails.logger.error "Asaas API Error: #{response.code} - #{response.body}"
        raise ApiError, error_message
      end
    end
  end
end
