require "active_support"

ActiveSupport::Inflector.inflections(:en) do |inflect|
  # Add uncountable words
  inflect.uncountable 'asaas'
end
