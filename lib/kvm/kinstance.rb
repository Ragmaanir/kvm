module Kvm
  class KInstance

    def initialize(klass)
      @klass = klass
      @attributes = []
    end

    def []=(attribute, value)
      @attributes[attribute] = value
    end

    def [](attribute)
      @attributes[attribute]
    end

    def to_s
      "#{@klass.name}(#{@attributes.join(',')})"
    end

  end
end
