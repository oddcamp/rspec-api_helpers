class Adapter::ActiveModel::Collection
  include Adapter::ActiveModel::CommonHelpers
  include RSpec::Matchers

  def initialize(options, response, _binding)
    @options = HashWithIndifferentAccess.new(options)
    @response = response
    @_binding = _binding
  end

  def has_size(size)
    expect(collection.size).to(eq size)
  end

  def sample(new_options = {})
    Adapter::ActiveModel::Resource.new(
      options.merge(new_options), collection.sample.hash, @_binding
    )
  end

  def find_by(id, new_options = {})
    resource = collection.find{|i| i.send(id).to_s == model.send(id).to_s}
    if resource.nil?
      raise "Resource was not found for id: #{id} (model value: #{model.send(id)})"
    end

    return Adapter::ActiveModel::Resource.new(
      options.merge(new_options), resource.hash, @_binding
    )
  end

  private
    attr_reader :options

    def model
      @model ||= parse_model(
        @_binding.instance_exec(&options[:model])
      )
    end

    def collection
      @collection ||= objectize_collection(
        @response, root: options[:resource]
      )
    end
end
