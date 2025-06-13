# pay-asaas

Asaas payment processor for Pay gem (Payments engine for Ruby on Rails);

> [!WARNING]
> This gem is a work in progress and is not ready for production use.

> This gem is not affiliated with Asaas.

The goal for the first implementation is to support the following features:

- [x] Customer creation
- [x] Make a payment with PIX
- [x] Support basic webhooks needed for the payment process
- [x] Pix QRCode sync

Following features will be implemented in the future and I will be happy to receive contributions:
- [ ] Credit Cards
- [ ] Subscriptions

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add pay-asaas;
```

> Install pay gem if you haven't already: https://github.com/pay-rails/pay/blob/main/docs/1_installation.md

## Configuration

### Rails Credentials

`rails credentials:edit --environment=development`

```yml
asaas:
  api_key: xxxx
  api_url: https://api-sandbox.asaas.com/v3 # or 	https://api.asaas.com/v3
  webhook_access_key: xxxx
```

### Environment Variables

Pay will also check environment variables for API keys:

- `ASAAS_API_KEY`
- `ASAAS_API_URL`
- `ASAAS_WEBHOOK_ACCESS_KEY`

> Se other configuration options at: https://github.com/pay-rails/pay/blob/main/docs/2_configuration.md

## Customer

**IMPORTANT**: In order to create a customer with pay-asaas, you need to provide a document (cpf or cnpj) to the user. This can be in the form of the following columns, in order of preference:
  - `document`
  - `cpf`
  - `cnpj`

In asaas, the document is not required to create the customer but is required to process payments, as such, we choose to make the field mandatory in this gem.

## Charge

This first version of the gem will only support PIX payments.

```ruby
@user.payment_processor.charge(15_00)

@user.payment_processor.charge(15_00, { attrs: { order_id: @order.id } })
```

## Webhooks

The gem provides a built-in controller to handle webhooks from Asaas. These webhooks are essential for keeping your payment records in sync with Asaas's systems.

### Configuration

To configure webhooks in your Asaas dashboard, use the following URL (replace `example.org` with your domain):

- **Asaas Webhook URL**: `https://example.org/pay/webhooks/asaas`

### Supported Events

The main goal of the webhooks right now is to sync payment statuses.

> For now we listen to the events that are important for pix transactions. For more configuration options
> see: https://github.com/pay-rails/pay/blob/main/docs/7_webhooks.md

### Verify Webhooks

All incoming webhooks from Asaas will be verified using the `webhook_access_key` provided in the gem configuration.

## Debugging

To debug HTTP requests made by our gem, which uses the httparty library, you can enable logging of all outgoing HTTP calls. Just add the following line to one of your initializers:

```ruby
HTTParty::Basement.debug_output($stdout)
```

This will print the full request and response details to the console, making it easier to troubleshoot issues during development.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pay-asaas. This project is intended
to be a safe, welcoming space for collaboration, and contributors are expected to adhere to
the [code of conduct](https://github.com/[USERNAME]/pay-asaas/blob/master/CODE_OF_CONDUCT.md).

### Running tests

In order to run the test, first add a .env with fake credentials at the root of the project, and create a database in the `spec/dummy` folder.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pay::Asaas project's codebases, issue trackers, chat rooms and mailing lists is expected to
follow the [code of conduct](https://github.com/[USERNAME]/pay-asaas/blob/master/CODE_OF_CONDUCT.md).
