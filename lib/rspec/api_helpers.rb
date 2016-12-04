require 'rspec/api_helpers/version'
require 'rspec/api_helpers/dispatcher'
require 'rspec/api_helpers/example_methods'
require 'rspec/api_helpers/example_group_methods'

module Rspec

  module ApiHelpers
    class << self;
      attr_accessor :adapter
    end

    def self.included(receiver)
      receiver.extend         ExampleGroupMethods
      receiver.send :include, ExampleMethods
    end

    def self.with(adapter:)
      if adapter.is_a?(Class)
        self.adapter = adapter
      else
        case adapter.to_s.to_sym
        when :active_model
          self.adapter = Adapter::ActiveModel
        when :json_api
          self.adapter = Adapter::JsonApi
        end
      end

      return self
    end
  end
end
