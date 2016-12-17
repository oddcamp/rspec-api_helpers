require "rspec/api_helpers/version"

module Rspec
  module ApiHelpers
    module ExampleMethods
      def dispatcher
        @dispatcher ||= Rspec::ApiHelpers::Dispatcher.new
      end
    end
  end
end


