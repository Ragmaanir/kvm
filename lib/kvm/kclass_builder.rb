module Kvm
  class KClassBuilder

    attr_reader :result

    def self.build(*args, &block)
      new(*args, &block).result
    end

    def initialize(name, superclass='Object', &block)
      @name = name
      @superclass = superclass
      @instance_methods = []
      @object_methods = []
      @attributes = []

      instance_eval(&block)

      @result = KClass.new(@name, @superclass, @attributes, @object_methods, @instance_methods)
    end

    def attribute(name, *args)
      #@attributes <<
    end

    def method(name, signature=[], options={}, &block)
      code = if options[:hardcoded]
        block
      else
        CodeBuilder.build(&block)
      end

      @instance_methods << Method.new(name, signature, options.merge(code_block: code))
    end

    def class_method(name, signature=[], options={}, &block)
      code = if options[:hardcoded]
        block
      else
        CodeBuilder.build(&block)
      end

      @object_methods << Method.new(name, signature, options.merge(code_block: code))
    end

  end
end
