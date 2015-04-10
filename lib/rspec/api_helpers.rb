require 'rspec/api_helpers/version'
require 'rspec/api_helpers/example_methods'
require 'rspec/api_helpers/example_group_methods'

module Rspec
  module ApiHelpers
    def self.included(receiver)
      receiver.extend         ExampleGroupMethods
      receiver.send :include, ExampleMethods
    end
  end
end
