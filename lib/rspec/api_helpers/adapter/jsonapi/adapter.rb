class Adapter
  class JsonApi
    include RSpec::Matchers

    class << self
      def resource(options, response, _binding)
        jsonapi_resource = HashWithIndifferentAccess.new(JSON.parse(response.body))

        jsonapi_resource = transform_resource(jsonapi_resource.dig('data') || {})

        return Adapter::ActiveModel::Resource.new(options, jsonapi_resource, _binding)
      end

      def collection(options, response, _binding)
        jsonapi_collection = HashWithIndifferentAccess.new(JSON.parse(response.body))

        jsonapi_collection = transform_collection(jsonapi_collection.dig('data') || {})

        return Adapter::ActiveModel::Collection.new(options, jsonapi_collection, _binding)
      end


      private
        def transform_resource(jsonapi_hash, root: true)
          type = jsonapi_hash.dig('type').singularize
          json_hash = jsonapi_hash.dig('attributes').transform_keys{|key|
            key.underscore
          }.merge(id: jsonapi_hash.dig('id').to_s)

          if root
            return HashWithIndifferentAccess.new({type => json_hash})
          else
            return HashWithIndifferentAccess.new(json_hash)
          end
        end

        def transform_collection(jsonapi_hash, root: true)
          type = jsonapi_hash.first.dig('type').pluralize

          json_hash = jsonapi_hash.map{|data|
            transform_resource(data, root: false)
          }

          if root
            return HashWithIndifferentAccess.new({type => json_hash})
          else
            return json_hash
          end
        end
    end
  end
end
