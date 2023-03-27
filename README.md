# UpdateValuesAll

The gem allows to update AR-records in batch

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add update_values_all

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install update_values_all

## Usage

Assume you have AR-model

```ruby
class User < ActiveRecord::Base
  store :address, accessors: %i[city]
end
```

And some records

```ruby
User.create!(id: 1, city: 'Moscow', name: 'Ivan')
User.create!(id: 2, city: 'Vladivostok', name: 'Petr')
```

The gem defines method `User.update_values_all` which allows to batch update attributes

```
changed_ids =
  User.update_values_all(
    [
      { id: 1, address: { city: 'Berlin' }, name: 'Hanz' },
      { id: 2, address: { city: 'London' }, name: 'John' }
    ],
    key_to_match: :id,
 )
```

changed_ids # [1, 2]
User.find(1).name # Hanz
User.find(1).city # Berlin
User.find(2).name # John
User.find(2).city # London

Records are only updated if attributes changed (and also `updated_at`).

Sometimes you want to update `updated_at` regardless of whether the attributes have changed. In that case you may pass param `touch: true`.

```
changed_ids = User.update_values_all([{ id: 1, name: 'Hanz' }], key_to_match: :id, touch: true)
```

changed_ids = []
User.find(1).updated_at # changed

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/corp-gp/update_values_all. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/corp-gp/update_values_all/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the UpdateValuesAll project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/corp-gp/update_values_all/blob/master/CODE_OF_CONDUCT.md).
