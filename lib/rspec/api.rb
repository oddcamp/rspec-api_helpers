require "rspec/api/version"

module Rspec
  module Api
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

    module ExampleGroupMethods
      def it_returns_status(status)
        it 'returns the correct status' do
          expect(last_response.status).to eql(status)
        end
      end

      def it_returns_attributes(resource:, model:, only: [], modifier: nil)
        it "expects returned resource to have the following model's attributes" do
          @api_resource = objectize_resource(last_response.body, root: resource)

          @model = eval(model)
          if @model.is_a? Hash
            @model = object_hash(@model)
          end

          if only
            only.each do |attribute|
              begin
                if modifier
                  expect(@api_resource.send(attribute)).to(
                    eql(@model.send(attribute).send(modifier.to_sym))
                  )
                else
                  expect(@api_resource.send(attribute)).to eql(@model.send(attribute))
                end
              rescue RSpec::Expectations::ExpectationNotMetError => e
                e.message << "failed at model attribute: #{attribute}"
                raise e
              end
            end
          end
        end

      end
      alias_method :it_returns_db_model, :it_returns_attributes
      alias_method :it_returns_more_attributes, :it_returns_attributes

      def it_includes_in_headers(headers: {})
        it 'returns the correct headers' do
          headers.each do |header, value|
            expect(last_response.headers[header.to_s]).to eq(eval(value))
          end
        end
      end

      def it_returns_the_resources(root:, number:)
        it 'returns the correct number of data in the body' do
          users = objectize_resources(last_response.body, root: root)
          expect(users.length).to eql(number)
        end
      end
    end
  end
end

def self.included(receiver)
  receiver.extend         ExampleGroupMethods
  receiver.send :include, ExampleMethods
end
