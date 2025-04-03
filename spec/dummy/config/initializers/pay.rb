Rails.application.config.to_prepare do
  Pay::Charge.include ChargeExtensions
end
