class Adapter::ActiveModel::Resource
  include Adapter::ActiveModel::CommonHelpers
  include RSpec::Matchers

  def initialize(options, response, _binding)
    @options = HashWithIndifferentAccess.new(options)
    @response = response
    @_binding = _binding
  end

  def resource
    @resource ||= objectize_resource(
      @response, root: options[:resource], existing: options[:existing]
    )
  end

  def compare_attribute(attribute)
    expect(resource.send(attribute)).to(
      eql(
        modifier_for(attribute).call(
          model.send(attribute)
        )
      )
    )
  end

  def embedded_collection(new_options = {})
    raise 'embeds option missing' unless (options[:embeds] || new_options[:embeds])

    Adapter::ActiveModel::Collection.new(
      options.merge(new_options), resource.send(options[:embeds]), @_binding
    )
  end

  def has_no_attribute(attribute)
    expect(resource.send(attribute)).to(eql(:attribute_not_found))
  end

  def has_attribute(attribute)
    expect(resource.send(attribute)).to_not(eql(:attribute_not_found))
  end

  private
    attr_reader :options

    def model
      raise 'model is missing' if options[:model].blank?

      @model ||= parse_model(
        @_binding.instance_exec(&options[:model])
      )
    end

    def attrs
      options[:attrs].map{|i| i.to_s}
    end

    def attrs?
      attrs.any?
    end

    def modifiers_hash
      return {} if options[:modifiers].blank?

      @modifiers_hash = {}
      options[:modifiers].each do |key, value|
        [key].flatten.each do |attr|
          if attrs?
            raise "#{attr} missing from :attrs param" unless attrs.include?(attr.to_s)
            @modifiers_hash[attr] = value
          end
        end
      end

      return @modifiers_hash
    end
end
