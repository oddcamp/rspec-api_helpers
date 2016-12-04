require 'rspec/api_helpers/adapter/jsonapi/adapter'
require 'rspec/api_helpers/adapter/active_model/adapter'
require 'rspec/api_helpers/adapter/active_model/common_helpers'
require 'rspec/api_helpers/adapter/active_model/resource'
require 'rspec/api_helpers/adapter/active_model/collection'


module Rspec
  module ApiHelpers
    class Dispatcher
      def adapter
        Rspec::ApiHelpers.adapter
      end
    end
  end
end
