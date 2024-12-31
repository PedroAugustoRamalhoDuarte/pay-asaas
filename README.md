# pay-asaas

Asaas payment processor for Pay gem (Payments engine for Ruby on Rails);

> This gem is a work in progress and is not ready for production use.

> This gem is not affiliated with Asaas.

The goal for the first implementation is to support the following features:

- [x] Customer creation
- [x] Make a payment with PIX
- [x] Support basic webhooks needed for the payment process

Following features will be implemented in the future and I will be happy to receive contributions:

- [ ] Pix QRCode sync
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
  api_url: https://sandbox.asaas.com/api/v3 # or https://www.asaas.com/api/v3
  webhook_access_key: xxxx
```

### Environment Variables

Pay will also check environment variables for API keys:

- `ASAAS_API_KEY`
- `ASAAS_API_URL`
- `ASAAS_WEBHOOK_ACCESS_KEY`

> Se other configuration options at: https://github.com/pay-rails/pay/blob/main/docs/2_configuration.md

## Customer

**IMPORTANT**: For this add the document column to users table.

The customer works the same as the other processors, but with the document additional field.

The document is not required to create the customer but is required to process payments. The document can be cpf ou cnpj
without mask.

## Charge

This first version of the gem will only support PIX payments.

```ruby
@user.payment_processor.charge(15_00)
```

## Webhooks

The gem will provide a controller to handle the webhooks.

To configure webhooks on your payment processor, use the following URLs while replacing example.org with your own
domain:

- Asaas: https://example.org/pay/webhooks/asaas

> For now we listen to the events that are important for pix transactions. For more configuration options
> see: https://github.com/pay-rails/pay/blob/main/docs/7_webhooks.md

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

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pay::Asaas project's codebases, issue trackers, chat rooms and mailing lists is expected to
follow the [code of conduct](https://github.com/[USERNAME]/pay-asaas/blob/master/CODE_OF_CONDUCT.md).
