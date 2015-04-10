require "rspec/api_helpers/version"

module Rspec
  module ApiHelpers
    module ExampleMethods
      def objectize_resources(json, root:)
        array = []
        array_hash = HashWithIndifferentAccess.new(MultiJson.load(json))

        if root
          array_hash = array_hash[root]
        end

        array_hash.each do |resource|
          array << object_hash(resource)
        end

        return array
      end

      def objectize_resource(json, root:)
        hash = HashWithIndifferentAccess.new(MultiJson.load(json))
        if root
          obj = object_hash(hash[root])
        else
          obj = object_hash(hash)
        end

        return obj
      end

      def object_hash(hash)
        ObjectHash.new(hash)
      end

      class ObjectHash
        attr_accessor :hash
        def initialize(hash)
          @hash = HashWithIndifferentAccess.new(hash)
        end
        def method_missing(name)
          return hash[name] if hash.key? name
          raise KeyError.new("Attribute not found in resource: #{name}")
        end
      end
    end
  end
end


