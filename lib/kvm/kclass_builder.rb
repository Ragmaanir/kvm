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
      @fields = []

      instance_eval(&block)

      @result = KClass.new(@name, @superclass, @fields, @object_methods, @instance_methods)
    end

    def field(name, type, *args)
      field = Field.new(name, type)
      raise ArgumentError if @fields.include?(field)
      @fields << field
    end

    def method(name, signature=[], options={}, &block)
      code = if options[:native]
        block
      else
        CodeBuilder.build(&block)
      end

      @instance_methods << Method.new(name, signature, options.merge(code_block: code))
    end

    def class_method(name, signature=[], options={}, &block)
      code = if options[:native]
        block
      else
        CodeBuilder.build(&block)
      end

      @object_methods << Method.new(name, signature, options.merge(code_block: code))
    end

  end
end
