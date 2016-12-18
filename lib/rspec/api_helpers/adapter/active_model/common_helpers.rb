module Adapter::ActiveModel::CommonHelpers
  def objectize_collection(collection, root: nil, existing: true)
    if root
      collection = collection[root]
    end

    return collection.map{|resource|
      object_hash(resource, existing: existing)
    }
  end

  def objectize_resource(resource, root: nil, existing: true)
    if root
      obj = object_hash(resource[root], existing: existing)
    else
      obj = object_hash(resource, existing: existing)
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

  def parse_model(model)
    return model unless model.is_a? Hash

    return object_hash(model)
  end

  def modifier_for(key)
    if modifiers_hash[key]
      return modifiers_hash[key]
    else
      return proc{|i| i}
    end
  end

end
