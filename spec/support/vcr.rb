require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr_cassettes"
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data("<ASAAS_API_KEY>") { Pay::Asaas::ApiClient.configuration.api_key }
end
