module Kvm
  class KInstance

    def initialize(klass)
      @klass = klass
      @attributes = []
    end

    def []=(attribute, value)
      slot = @klass.attribute_slot(attribute)
      @attributes[slot] = value
    end

    def [](attribute)
      slot = @klass.attribute_slot(attribute)
      @attributes[slot]
    end

    def to_s
      "#{@klass.name}(#{@attributes.join(',')})"
    end

  end
end
