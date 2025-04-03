require "dotenv/load"
require "pay/asaas"
require "database_cleaner-active_record"

ENV["RAILS_ENV"] ||= "test"

require_relative "../spec/dummy/config/environment"

ENV["RAILS_ROOT"] ||= "#{File.dirname(__FILE__)}../../../spec/dummy"

require "rspec/rails"
require "webmock/rspec"
require "support/vcr"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Rails logger configuration
  config.before(:suite) do
    Rails.logger = Logger.new($stdout)
    Rails.logger.level = Logger::ERROR
  end

  # Database cleaner configuration
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
