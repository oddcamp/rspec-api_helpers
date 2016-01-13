module Rspec
  module ApiHelpers
    module ExampleGroupMethods
      def it_returns_status(status)
        it "returns the correct HTTP status (status: #{status})" do
          expect(last_response.status).to eql(status)
        end
      end

      def it_returns_attribute_values(resource:, model:, only: [], modifier: {})
        it "expects returned resource (#{resource}) to have model attribute values" do
          api_resource = objectize_resource(last_response.body, root: resource)

          modifier = HashWithIndifferentAccess.new(modifier)

          model = eval(model)
          if model.is_a? Hash
            model = object_hash(model)
          end

          if only
            only.each do |attribute|
              begin
                if modifier.has_key?(attribute)
                  modifier[attribute] = [modifier[attribute]].flatten

                  expect(api_resource.send(attribute)).to(
                    eql(
                      modifier[attribute].inject(
                        model.send(attribute), :send
                      )
                    )
                  )
                else
                  expect(api_resource.send(attribute)).to(
                    eql(model.send(attribute))
                  )
                end
              rescue RSpec::Expectations::ExpectationNotMetError => e
                e.message << "failed at model attribute: #{attribute}"
                raise e
              end
            end
          end
        end

      end
      alias_method :it_returns_more_attribute_values, :it_returns_attribute_values


      def it_returns_no_attributes(resource:, attributes: [])
        it "expects returned resource (#{resource}) to NOT have the following attributes" do
          api_resource = objectize_resource(
            last_response.body, root: resource, existing: false
          )

          attributes.each do |attribute|
            begin
              expect(api_resource.send(attribute)).to eql(:attribute_not_found)
            rescue RSpec::Expectations::ExpectationNotMetError => e
              e.message << "failed at model attribute: #{attribute}"
              raise e
            end
          end
        end
      end

      def it_includes_in_headers(headers = {})
        headers.each do |header, value|
          it "returns headers #{header} wih value: #{value}" do
            expect(last_response.headers[header.to_s]).to eq(eval(value))
          end
        end
      end

      def it_returns_collection_size(resource:, size:)
        it "returns the correct number of resources in the #{resource} collection" do
          resources = objectize_resources(last_response.body, root: resource)
          expect(resources.length).to eql(size)
        end
      end

      def it_returns_collection_embedded_size(resource:, embeds:, size:)
        it "returns the correct number of embedded resource #{embeds} in the #{resource} collection" do
          resources = objectize_resources(last_response.body, root: resource)
          expect(resources.sample[embeds].length).to eql(size)
        end
      end

      def it_returns_embedded_size(resource:, embeds:, size:)
        it "returns the correct number of embedded resource #{embeds} in the #{resource} resource" do
          resource = objectize_resource(last_response.body, root: resource)
          expect(resource.send(embeds).length).to eql(size)
        end
      end

      def it_returns_collection_attributes(resource:, attributes: [], subset: true)
        it "returns the correct attributes (no value checking) for each resource in the #{resource} collection" do
          resources = objectize_resources(last_response.body, root: resource.pluralize)

          resource_attributes_set = SortedSet.new(
            resources.sample.hash.keys.map(&:to_s)
          )
          checking_attributes_set = SortedSet.new(attributes.map(&:to_s).to_set)

          if subset
            begin
              expect(resource_attributes_set.superset?(checking_attributes_set)).to(
                eq(true)
              )
            rescue RSpec::Expectations::ExpectationNotMetError => _
              raise(
                $!,
                superset_mismatch_error(
                  resource_attributes_set, checking_attributes_set
                ),
                $!.backtrace
              )
            end
          else
            expect(resource_attributes_set).to eq(checking_attributes_set)
          end
        end
      end
      alias_method(
        :it_returns_more_collection_attributes,
        :it_returns_collection_attributes
      )

      def it_returns_collection_embedded_resource_attributes(
        resource:, embeds:, attributes: [], subset: true
      )
        it "returns the correct attributes (no value checking) of #{embeds} resource inside #{resource} collection" do
          resource = objectize_resources(last_response.body, root: resource)
          embedded_resource = object_hash(resource.sample.send(embeds.to_sym))

          embedded_resource_attributes_set = SortedSet.new(
            embedded_resource.hash.keys.map(&:to_s)
          )
          checking_attributes_set = SortedSet.new(attributes.map(&:to_s).to_set)

          if subset
            begin
              expect(
                embedded_resource_attributes_set.superset?(
                  checking_attributes_set
                )
              ).to(
                eq(true)
              )
            rescue RSpec::Expectations::ExpectationNotMetError => _
              raise(
                $!,
                superset_mismatch_error(
                  embedded_resource_attributes_set, checking_attributes_set
                ),
                $!.backtrace
              )
            end
          else
            expect(resource_attributes_set).to eq(checking_attributes_set)
          end
        end

      end

      def it_returns_no_collection_attributes(resource:, attributes: [])
        it "expects returned collection (#{resource}) to NOT have the following attributes" do
          resources = objectize_resources(
            last_response.body, root: resource.pluralize, existing: false
          )

          attributes.each do |attribute|
            begin
              expect(resources.sample.send(attribute)).to eql(:attribute_not_found)
            rescue RSpec::Expectations::ExpectationNotMetError => e
              e.message << "failed at model attribute: #{attribute}"
              raise e
            end
          end
        end
      end

      def it_returns_no_collection_embedded_resource_attributes(
        resource:, embeds:, attributes: []
      )
        it "expects the embedded resource #{embeds} inside the returned collection (#{resource}) to NOT have the following attributes" do
          resources = objectize_resources(
            last_response.body, root: resource.pluralize
          )

          embedded_resource = object_hash(
            resources.sample.send(embeds.to_sym), existing: false
          )

          attributes.each do |attribute|
            begin
              expect(embedded_resource.send(attribute)).to eql(:attribute_not_found)
            rescue RSpec::Expectations::ExpectationNotMetError => e
              e.message << "failed at model attribute: #{attribute}"
              raise e
            end
          end
        end
      end

    end
  end
end
