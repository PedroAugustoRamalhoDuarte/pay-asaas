Pay::Asaas::Engine.routes.draw do
  post "webhooks/asaas", to: "pay/webhooks/asaas#create" if Pay::Asaas.enabled?
end
