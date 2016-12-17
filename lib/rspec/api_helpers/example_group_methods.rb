module Rspec
  module ApiHelpers
    module ExampleGroupMethods
      def it_returns_status(status)
        it "returns the correct HTTP status (status: #{status})" do
          expect(last_response.status).to eql(status)
        end
      end

      #make rehashable
      def it_includes_in_headers(headers = {})
        headers.each do |header, value|
          it "returns headers #{header} wih value: #{value}" do
            expect(last_response.headers[header.to_s]).to eq(eval(value))
          end
        end
      end

      def it_returns_attribute_values(options = {})
        it "expects returned resource (#{options[:resource]}) to have model attribute values" do
          resource = dispatcher.adapter.resource(options.merge(existing: true), last_response, self)

          #support proc on attrs
          options[:attrs].each do |attribute|
            begin
              resource.compare_attribute(attribute)
            rescue RSpec::Expectations::ExpectationNotMetError => e
              e.message << "failed at model attribute: #{attribute}"
              raise e
            end
          end
        end
      end
      alias_method :it_returns_more_attribute_values, :it_returns_attribute_values

      def it_returns_no_attributes(options = {})
        it "expects returned resource (#{options[:root]}) to NOT have the following attributes" do
          resource = dispatcher.adapter.resource(options.merge(existing: false), last_response, self)

          options[:attrs].each do |attribute|
            begin
              resource.has_no_attribute(attribute)
            rescue RSpec::Expectations::ExpectationNotMetError => e
              e.message << "failed at model attribute: #{attribute}"
              raise e
            end
          end
        end
      end

      def it_returns_collection_size(options = {})
        it "returns the correct number of resources in the #{options[:resource]} collection" do
          collection = dispatcher.adapter.collection(options.merge(existing: true), last_response, self)

          collection.has_size(options[:size])
        end
      end

      def it_returns_collection_attributes(options = {})
        it "returns the correct attributes (no value checking) for resources in the #{options[:resource]} collection" do
          sample_resource = dispatcher.adapter.collection(
            options, last_response, self
          ).sample(existing: true, resource: nil)

          #support proc on attrs
          options[:attrs].each do |attribute|
            begin
              sample_resource.has_attribute(attribute)
            rescue RSpec::Expectations::ExpectationNotMetError => e
              e.message << "failed at model attribute: #{attribute}"
              raise e
            end
          end
        end
      end
      alias_method(
        :it_returns_more_collection_attributes,
        :it_returns_collection_attributes
      )

      def it_returns_no_collection_attributes(options = {})
        it "expects returned collection (#{options[:resource]}) to NOT have the following attributes" do
          sample_resource = dispatcher.adapter.collection(
            options, last_response, self
          ).sample(existing: false, resource: nil)

          #support proc on attrs
          options[:attrs].each do |attribute|
            begin
              sample_resource.has_no_attribute(attribute)
            rescue RSpec::Expectations::ExpectationNotMetError => e
              e.message << "failed at model attribute: #{attribute}"
              raise e
            end
          end
        end
      end

      #finds_by id
      def it_returns_collection_attribute_values(options = {})
        it "expects returned collection (#{options[:resource]}) to have model attribute values" do
          resource = dispatcher.adapter.collection(
            options, last_response, self
          ).find_by(:id, existing: true, resource: nil)

          #support proc on attrs
          options[:attrs].each do |attribute|
            begin
              resource.compare_attribute(attribute)
            rescue RSpec::Expectations::ExpectationNotMetError => e
              e.message << "failed at model attribute: #{attribute}"
              raise e
            end
          end
        end
      end

=begin
      #not tested
      def it_returns_embedded_collection_size(options = {})
        it "returns the correct number of embedded resource #{embeds} in the #{resource} resource" do
          collection = dispatcher.adapter.resource(
            options.merge(existing: true), last_response, self
          ).embedded_collection

          collection.has_size(options[:size])
        end
      end

      def it_returns_collection_embedded_collection_size(options = {})
        it "returns the correct number of embedded resource #{embeds} in the #{resource} collection" do

        end
      end

      def it_returns_collection_embedded_resource_attributes(options = {})
        it "returns the correct attributes (no value checking) of #{embeds} resource inside #{resource} collection" do

        end
      end

      def it_returns_no_collection_embedded_resource_attributes(options = {})
        it "expects the embedded resource #{embeds} inside the returned collection (#{resource}) to NOT have the following attributes" do

        end
      end
=end
    end
  end
end
