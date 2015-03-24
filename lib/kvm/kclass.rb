module Kvm
  class KClass

    attr_reader :name, :superclass, :attributes, :object_methods, :instance_methods

    def initialize(name, superclass, attributes, object_methods, instance_methods)
      @name = name
      @superclass = superclass
      @attributes = attributes
      @object_methods = object_methods
      @instance_methods = instance_methods
    end

    def get_method(id)
      raise ArgumentError unless id
      instance_methods.find{ |m| m.name.to_s == id } || raise("Could not find instance method #{id.inspect} in #{name}")
    end

    def get_object_method(id)
      raise ArgumentError unless id
      object_methods.find{ |m| m.name.to_s == id } || raise("Could not find object method #{id.inspect} in #{name}")
    end

  end
end
