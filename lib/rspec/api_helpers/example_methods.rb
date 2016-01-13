require "rspec/api_helpers/version"

module Rspec
  module ApiHelpers
    module ExampleMethods
      def objectize_resources(json, root:, existing: true)
        array = []
        array_hash = HashWithIndifferentAccess.new(JSON.parse(json))

        if root
          array_hash = array_hash[root]
        end

        array_hash.each do |resource|
          array << object_hash(resource, existing: existing)
        end

        return array
      end

      def objectize_resource(json, root:, existing: true)
        hash = HashWithIndifferentAccess.new(JSON.parse(json))
        if root
          obj = object_hash(hash[root], existing: existing)
        else
          obj = object_hash(hash, existing: existing)
        end

        return obj
      end

      def object_hash(hash, existing: true)
        ObjectHash.new(hash, existing: existing)
      end

      class ObjectHash
        #existing denotes whether we search for attributes that exist on the
        #resource or attributes that shouldn't exist
        attr_accessor :hash, :existing
        def initialize(hash, existing: true)
          @hash = HashWithIndifferentAccess.new(hash)
          @existing = existing
        end
        def method_missing(name)
          if existing
            if hash.key?(name)
              return hash[name]
            else
              return raise KeyError.new("Attribute not found in resource: #{name}")
            end
          else
            if hash.key?(name)
              return raise(
                KeyError.new(
                  "Attribute found in resource when it shouldn't: #{name}"
                )
              )
            else
              return :attribute_not_found
            end
          end
        end
      end

      def superset_mismatch_error(superset, subset)
        "Expected \n #{subset.to_a.to_s} \n to be included in \n #{superset.to_a.to_s}"
      end
    end
  end
end


