# Rspec::ApiHelpers

Usefull Rspec helpers for APIs (currently JSONAPI and AM-JSON adapters are supported)

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


**First you need to specify the adapter you want to use**

```ruby
RSpec.configure do |config|
  config.include Rspec::ApiHelpers.with(adapter: :json_api)
end
```
Other possible options for the adapter is `active_model`.

You can also inject your custom made class by providing the class:
```ruby
RSpec.configure do |config|
  config.include Rspec::ApiHelpers.with(adapter: Adapter::Hal)
end
```


### Examples
The library heavily uses dynamic scopes through procs (an alternative to eval).


#### General

```ruby
it_returns_status(200)
```
It expects the HTTP response status to be 200.

```ruby
it_includes_in_headers('SESSION_TOKEN' => proc{@user.token})
```
It expects the HTTP response to include this header (and value).

#### Resource

```ruby
it_returns_attributes(resource: 'user', model: '@user', attrs: [
  :email, :name
])
```

It expects the JSON resource to contain :email and :name attributes and
be equal with with `@user` methods.


```ruby
it_returns_attribute_values(
  resource: 'user', model: proc{@user}, attrs: [
    :id, :name, :email, :admin, :activated, :created_at, :updated_at
  ], modifiers: {
    [:created_at, :updated_at] => proc{|i| i.iso8601},
    :id => proc{|i| i.to_s}
  }
)
```
It expects the JSON resource to contain specific attribute values as above but for
`:updated_at`, `:created_at` and `id` it applies specific methods first, defined in the
`modifier` hash (note that the methods are applied in the JSON resource, not in the variable)

```ruby
it_returns_no_attributes(
  resource: 'user', attrs: [:foo1, :foo2, :foo3]
)
```
It expects the JSON resource to NOT contain any of those attributes.

#### Collection
```ruby
it_returns_collection_size(resource: 'users', size: 6)
```

It expects the JSON collection to have `6` resources.

```ruby
it_returns_collection_attributes(
  resource: 'users', attrs: [
    :id, :name, :email, :admin, :activated, :created_at, :updated_at
  ]
)
```

It expects the JSON collection to have those attributes (no value checking).


```ruby
it_returns_no_collection_attributes(
  resource: 'users', attrs: [
    :foo
  ]
)
```

It expects the JSON collection NOT to have those attributes (no value checking).


```ruby
it_returns_collection_attribute_values(
  resource: 'users', model: proc{User.first!}, attrs: [
    :id, :name, :email, :admin, :activated, :created_at, :updated_at
  ], modifiers: {
    [:created_at, :updated_at] => proc{|i| i.iso8601},
    :id => proc{|i| i.to_s}
  }
)
```

It expects the JSON collection to contain specific attribute values as above but for
`:updated_at`, `:created_at` and `id` it applies specific methods first, defined in the
`modifier` hash (note that the methods are applied in the JSON resource, not in the variable)


## To Do
* Enhance documentation
* Better dir structure (break example group methods to modules)
* Support for nested resources
* Add tests
* Support for HAL/Siren adapter

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rspec-api_helpers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
