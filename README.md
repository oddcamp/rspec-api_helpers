# Rspec::ApiHelpers

Usefull Rspec helpers for APIs (currently only ActiveModel Serializers are supported)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-api_helpers', github: 'kollegorna/rspec-api_helpers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-api_helpers

## Usage
This Gem expects you to have set your rspec to use Rake::Test helpers as described
[here](https://gist.github.com/alex-zige/5795358) because it checks `last_response`
attributes.

In your `rails_helper.rb` add in the top:

```ruby
require 'rspec/api_helpers'
```

and then you only need to include the helpers in your rspec examples. You can include them on all api (:type => :api) helpers by adding the following line in your rspec config:

```ruby
  config.include Rspec::ApiHelpers, type: :api
```


### Examples

```ruby
it_returns_status(200)
```
It checks if the HTTP response status is 200.

```ruby
it_returns_attributes(resource: 'user', model: '@user', only: [
  :email, :name
])
```
It checks if the HTTP body contains an AMS json that has :email and :name attributes and
compares them with '@user' variable's attributes.

```ruby
it_returns_more_attributes(
  resource: 'user',
  model: 'User.last!',
  only: [:updated_at, :created_at],
  modifier: 'iso8601'
)
```
It checks if the HTTP body contains an AMS json that has :updated_at and :created_at
attributes and compares them with '@user' variable's attributes after it applies modifier.

```ruby
it_returns_resources(root: 'users', number: 5)
```
It checks if the HTTP body contains an AMS json with an array of 'users'.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rspec-api_helpers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
